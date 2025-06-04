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
        inputs.home-manager.nixosModules.home-manager
        inputs.clan-core.clanModules.trusted-nix-caches
        (import ./options.nix {
          inherit inputs system;
        })
      ] ++ extraModules;
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
        ../home/default.nix
        {

          nixpkgs = {
            overlays = [ (import ../overlays inputs) ];
            config = {
              allowUnfree = true;
            };
          };
        }
      ] ++ extraModules;
    };
in
{
  inherit
    mkDarwinHost
    mkNixHost
    mkHMConfig
    ;
}
