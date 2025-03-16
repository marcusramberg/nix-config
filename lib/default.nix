{
  inputs,
}:
let
  mkDarwinHost =
    name:
    {
      inputs,
      system,
      user ? "marcus",
      overlays,
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit user;
      };
      modules = [
        # Main `nix-darwin` config
        ../hosts/${name}
        ../darwin
        # `home-manager` module
        inputs.home-manager.darwinModules.home-manager
        (mkOptions {
          inherit
            user
            overlays
            inputs
            system
            ;
        })
      ];
    };

  mkNixHost =
    name:
    {
      inputs,
      system,
      overlays,
      deployment ? { },
      extraModules ? [ ],
    }:
    {
      imports = [
        ../hosts/${name}
        ../nixos
        ../cachix.nix
        inputs.home-manager.nixosModules.home-manager
        (mkOptions {
          inherit
            overlays
            inputs
            system
            ;
        })
        {
          deployment = {
            targetUser = "marcus";
          } // deployment;
        }
      ] ++ extraModules;

    };
  mkHMConfig =
    {
      inputs,
      pkgs,
      user ? "marcus",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs user;
        osConfig = {
          system = { };
          networking = {
            hostName = "";
          };
        };
      };
      modules = [ ../home/default.nix ];
    };

  mkOptions =
    {
      user ? "marcus",
      inputs,
      overlays,
      system,
      ...
    }:
    {
      nixpkgs = {
        inherit overlays;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnsupportedSystem = true;
        };
        hostPlatform = system;
      };

      home-manager = {
        # verbose = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";
        useUserPackages = true;
        users.${user} = import ../home;
        extraSpecialArgs = {
          inherit inputs user;
        };
      };
    };
  overlays = [
    (import ../overlays inputs)
  ];
in
{
  inherit
    mkDarwinHost
    mkNixHost
    mkHMConfig
    overlays
    ;
}
