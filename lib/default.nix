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
        inherit inputs user;
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

  mkColmenaHive =
    nixpkgs: nodeDeployments:
    let
      confs = inputs.self.nixosConfigurations;
      colmenaConf =
        {
          meta = {
            inherit nixpkgs;
            nodeNixpkgs = builtins.mapAttrs (_name: value: value.pkgs) confs;
            nodeSpecialArgs = builtins.mapAttrs (_name: value: value._module.specialArgs) confs;
          };
        }
        // builtins.mapAttrs (nodeName: value: {
          imports = value._module.args.modules;
          deployment = {
            targetUser = "marcus";
            allowLocalDeployment = true;
          } // nodeDeployments.${nodeName} or { };
        }) confs;
    in
    inputs.colmena.lib.makeHive colmenaConf;

  mkNixHost =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
      user ? "marcus",
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs user;
      };
      modules = [
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
          networking.hostName = name;
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
    mkColmenaHive
    mkNixHost
    mkHMConfig
    ;
}
