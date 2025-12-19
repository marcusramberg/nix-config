{
  inputs,
}:
let
  mkDarwinHost =
    name:
    {
      system ? "aarch64-darwin",
      user ? "marcus",
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit user inputs;
      };
      modules = [
        # Main `nix-darwin` config
        ../machines/${name}
        ../darwin
        # `home-manager` module
        inputs.home-manager.darwinModules.home-manager
        (import ./options.nix {
          inherit inputs system;
        })
      ];
    };

  mkDesktopHost =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    let
      modules = [
        {
          profiles.desktop.enable = true;
        }
      ]
      ++ extraModules;
    in
    mkNixHost name {
      inherit system;
      extraModules = modules;
    };
  mkNixHost =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    {
      imports = [
        ../nixos
        inputs.agenix.nixosModules.age
        {
          nixpkgs.overlays = [
            inputs.quickshell.overlays.default
          ];
        }
        inputs.home-manager.nixosModules.home-manager
        (import ./options.nix {
          inherit inputs system;
        })
      ]
      ++ extraModules;
      clan.core.networking.targetHost = "root@${name}";
      nixpkgs.hostPlatform = system;
    };
  mkHMConfig =
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
      user ? "marcus",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit user inputs;
        osConfig = {
          system = { };
          networking = {
            hostName = "";
          };
        };
      };
      modules = [
        {
          nixpkgs = {
            overlays = [ (import ../overlays inputs) ];
            config = {
              allowUnfree = true;
            };
          };
        }
        ../home/default.nix
      ]
      ++ extraModules;
    };
in
{
  inherit
    mkDarwinHost
    mkNixHost
    mkDesktopHost
    mkHMConfig
    ;
}
