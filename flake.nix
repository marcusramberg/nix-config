{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs @ { self, nixpkgs, home-manager, neovim-nightly-overlay, darwin }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues optionalAttrs singleton;
      system = "x86_64-linux";
      secrets = import ./secrets;
      nixpkgsConfig = {
        config = { allowUnfree = true; allowBroken = true; allowUnsupportedSystem = true; };
      };
    in
    {
      nixosConfigurations = {
        mhub = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; inherit secrets; };
          modules = [
            ./hosts/mhub
            ./nixos
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marcus = import ./home;
            }
          ];
        };
        butterbee = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; inherit secrets; };
          modules = [
            ./hosts/butterbee
            ./nixos
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marcus = import ./home;
            }
          ];
        };
      };

      darwinConfigurations.mbook = darwinSystem {
        system = "aarch64-darwin";
        modules = attrValues self.darwinModules ++ [
          # Main `nix-darwin` config
          ./darwin
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # inherit nix-doom-emacs;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marcus = import ./home;
          }
        ];
      };
      darwinModules = {
        programs-nix-index =
          # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
          { config, lib, pkgs, ... }:

          {
            config = lib.mkIf config.programs.nix-index.enable {
              programs.fish.interactiveShellInit = ''
                function __fish_command_not_found_handler --on-event="fish_command_not_found"
                  ${if config.programs.fish.useBabelfish then ''
                  command_not_found_handle $argv
                  '' else ''
                  ${pkgs.bashInteractive}/bin/bash -c \
                    "source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                  ''}
                end
              '';
            };
          };
      };


    };
}
