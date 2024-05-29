rec {
  mkDarwinHost =
    {
      inputs,
      system,
      user ? "marcus",
      overlays,
      std,
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit user;
      };
      modules = [
        # Main `nix-darwin` config
        ../darwin
        # `home-manager` module
        inputs.home-manager.darwinModules.home-manager
        (mkOptions {
          inherit user;
          inherit overlays;
          inherit inputs;
          inherit std;
        })
      ];
    };

  mkNixHost =
    name:
    {
      nixpkgs,
      inputs,
      system,
      user ? "marcus",
      overlays,
      std,
      extraModules ? null,
    }:
    let
      inherit (nixpkgs) lib;
    in
    lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit user;
      };
      inherit system;
      modules = lib.lists.flatten (
        [
          ../hosts/${name}
          ../nixos
          inputs.nur.nixosModules.nur
          inputs.home-manager.nixosModules.home-manager
          (mkOptions {
            inherit user;
            inherit overlays;
            inherit inputs;
            inherit std;
          })
        ]
        ++ lib.optional (extraModules != null) extraModules
      );
    };
  mkHMConfig =
    {
      inputs,
      pkgs,
      std,
      user ? "marcus",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs std user;
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
      user,
      inputs,
      overlays,
      std,
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
      };

      home-manager = {
        # verbose = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";
        useUserPackages = true;
        users.${user} = import ../home;
        extraSpecialArgs = {
          inherit inputs std user;
        };
      };
    };
}
