{
  inputs,
}:
let
  mkDarwinHost =
    name:
    {
      system ? "aaarch64-darwin",
      user ? "marcus",
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
            inputs
            system
            ;
        })
      ];
    };

  mkNixHost =
    name:
    {
      system ? "x86_64-linux",
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
            system
            ;
        })
        {
          deployment = {
            targetUser = "marcus";
            allowLocalDeployment = true;
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
    ;
}
