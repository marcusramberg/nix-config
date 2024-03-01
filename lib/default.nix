rec {
  mkDarwinHost = { inputs, system, user ? "marcus", overlays, std }:
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
        (mkOptions system {
          inherit user;
          inherit overlays;
          inherit inputs;
          inherit std;
        })
      ];
    };

  mkNixHost = name:
    { nixpkgs, inputs, system, user ? "marcus", overlays, std
    , extraModules ? null }:
    let inherit (nixpkgs) lib;
    in lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit user;
      };
      inherit system;
      modules = lib.lists.flatten ([
        ../hosts/${name}
        ../nixos
        inputs.nur.nixosModules.nur
        inputs.home-manager.nixosModules.home-manager
        (mkOptions system {
          inherit user;
          inherit overlays;
          inherit inputs;
          inherit std;
        })
      ] ++ lib.optional (extraModules != null) extraModules);
    };

  mkOptions = system:
    { user, inputs, overlays, std, ... }:
    let stable = inputs.stable.legacyPackages.${system};
    in {
      nixpkgs = {
        # inherit overlays;
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
        useUserPackages = true;
        users.${user} = import ../home;
        extraSpecialArgs = {
          inherit inputs;
          inherit stable;
          inherit std;
        };
      };
    };
}
