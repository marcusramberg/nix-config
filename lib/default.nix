{
  inputs,
}:
let

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
            # inputs.quickshell.overlays.default
            inputs.niri.overlays.niri
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
          networking.hostName = "";
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
    mkNixHost
    mkDesktopHost
    mkHMConfig
    ;
}
