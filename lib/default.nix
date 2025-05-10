{
  inputs,
  patches ? _: { },
  hostSystem ? builtins.currentSystem,
}:
let
  pkgsForPatching = import inputs.nixpkgs { system = hostSystem; };

  patchFetchers = rec {
    pr =
      repo: id: hash:
      pkgsForPatching.fetchpatch2 {
        url = "https://github.com/${repo}/pull/${builtins.toString id}.diff";
        sha256 = hash;
      };
    npr = pr "NixOS/nixpkgs";
  };

  fetchedPatches = patches patchFetchers;

  patchInput =
    name: value:
    if (fetchedPatches.${name} or [ ]) != [ ] then
      let
        patchedSrc = pkgsForPatching.applyPatches {
          name = "source";
          src = value;
          patches = fetchedPatches.${name};
        };
      in
      patchedSrc
    else
      value;

  patchedInputs = builtins.mapAttrs patchInput inputs;
  patchedNixpkgs = import patchedInputs.nixpkgs;

  mkDarwinHost =
    name:
    {
      system ? "aarch64-darwin",
      user ? "marcus",
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inputs = patchedInputs;
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
          } // nodeDeployments.${nodeName};
        }) (nixpkgs.lib.filterAttrs (n: _: builtins.hasAttr n nodeDeployments) confs);
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
        inputs = patchedInputs;
        inherit user;
      };
      modules = [
        ../hosts/${name}
        ../nixos
        patchedInputs.home-manager.nixosModules.home-manager
        (mkOptions {
          inherit system;
        })
        {
          networking.hostName = name;
        }
      ] ++ extraModules;

    };
  mkHMConfig =
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
      user ? "marcus",
    }:
    patchedInputs.home-manager.lib.homeManagerConfiguration {
      pkgs = patchedNixpkgs { inherit system; };
      extraSpecialArgs = {
        inputs = patchedInputs;
        inherit user;
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
            inherit overlays;
            config = {
              allowUnfree = true;
            };
          };
        }
      ] ++ extraModules;
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
          inherit user;
          inputs = patchedInputs;
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
