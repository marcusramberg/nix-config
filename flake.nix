{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stable.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    tfenv.url = "github:tfutils/tfenv";
    tfenv.flake = false;
  };

  outputs = { self, ... } @inputs:
    with inputs;
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues;

      mkNixHost = import lib/mkNixHost.nix;
      overlays.default = final: prev: (import ./overlays inputs) final prev;
      homeManagerConfig = {
        nixpkgs = {
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.marcus = import ./home;
          # extraSpecialArgs = {
          #   stable = stable.legacyPackages.${system};
          # };
        };
      };
    in
    {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
          inherit overlays nixpkgs home-manager inputs;
          system = "x86_64-linux";
          user = "marcus";
        };
        butterbee = mkNixHost "butterbee" {
          inherit overlays nixpkgs home-manager inputs;
          system = "aarch64-darwin";
          user = "marcus";
        };
        mbox = mkNixHost "mbox" {
          inherit overlays nixpkgs home-manager inputs;
          system = "aarch64-darwin";
          user = "marcus";
        };
      };

      darwinConfigurations.mbook = darwinSystem
        {
          system = "aarch64-darwin";
          modules = attrValues self.darwinModules ++ [
            # Main `nix-darwin` config
            ./darwin
            # `home-manager` module
            home-manager.darwinModules.home-manager
            homeManagerConfig
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
