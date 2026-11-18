{
  description = "nix.means.no";

  outputs =
    {
      self,
      flake-parts,
      hei,
      ...

    }@originalInputs:
    let
      inherit
        (import ./lib {
          inputs = originalInputs;
          nixpkgsPRs = [
            # {
            #   number = 572284;
            #   hash = "sha256-iiGKgHQeke+0jrMM5h0ajvymEkvE/Qbp6wUm1XPCSAI=";
            # }
          ];
        })
        inputs
        mkNixHost
        mkDesktopHost
        mkHMConfig
        ;
    in
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.clan-core.flakeModules.default
      ];
      clan = {
        # Clan wide settings. (Required)
        meta.name = "means_no";
        inventory.instances = {
          clan-cache = {
            module = {
              name = "trusted-nix-caches";
              input = "clan-core";
            };
          };
        };
        machines = {
          mstudio = mkDesktopHost "mstudio" {
            extraModules = [
              inputs.apple-silicon-support.nixosModules.apple-silicon-support
            ];
            system = "aarch64-linux";
          };
          mhub = mkNixHost "mhub" { };
          mbox = mkNixHost "mbox" {
            extraModules = [ inputs.jovian.nixosModules.default ];
          };
          mwork = mkDesktopHost "mwork" { };
          mdesk = mkDesktopHost "mdesk" { };
          mtop = mkDesktopHost "mtop" { };
          mbench = mkNixHost "mbench" {
          };
          mdeck = mkNixHost "mdeck" {
            extraModules = [
              inputs.jovian.nixosModules.default
              inputs.springchick.nixosModules.springchick
            ];
          };
          mgrate = mkDesktopHost "mgrate" { };
          mwall = mkNixHost "mwall" {
            system = "aarch64-linux";
            extraModules = [ inputs.nixos-bpi-r4-pro.nixosModules.default ];
          };
          mlab = mkDesktopHost "mlab" { };
          mrack01 = mkNixHost "mrack01" { };
          mvirt = mkNixHost "mvirt" { };
          mpixel = mkNixHost "mpixel" {
            system = "aarch64-linux";
            extraModules = [
              inputs.springchick.nixosModules.springchick
              inputs.nixos-pixel-9pro.nixosModules.default
            ];
          };
          dmsmobile = mkNixHost "dmsmobile" {
            system = "aarch64-linux";
            extraModules = [
              inputs.springchick.nixosModules.springchick
              inputs.vanilla-mobile-nixos.nixosModules.vanilla-mobile
            ];
          };
          mfajita = mkNixHost "mfajita" {
            system = "aarch64-linux";
            extraModules = [
              inputs.springchick.nixosModules.springchick
              inputs.vanilla-mobile-nixos.nixosModules.vanilla-mobile
            ];
          };
	  multron = mkDesktopHost "multron" {
	  system="aarch64-linux";
	  extraModules = [
            inputs.aurora.inputs.apple-silicon.nixosModules.default
            inputs.aurora.nixosModules.default 
	    inputs.aurora.nixosModules.image 
	    inputs.aurora.nixosModules.installed
            { nixpkgs.overlays = [ inputs.aurora.inputs.apple-silicon.overlays.default inputs.aurora.overlays.default ]; }

	  ];
	  };
        };
        specialArgs = { inherit inputs self; };
      };
      flake = {
        # Aurora's binary cache only matches its own nixpkgs pin, and our newer
        # NixOS modules don't evaluate against those packages.
        nixosConfigurations.multron = inputs.nixpkgs.lib.mkForce (
          inputs.aurora.inputs.nixpkgs.lib.nixosSystem {
            modules = [ self.nixosModules.clan-machine-multron ];
            specialArgs = {
              inherit inputs self;
              inherit (inputs) clan-core;
            };
          }
        );
        installers = builtins.mapAttrs (
          _: config:
          (inputs.unattended-installer.lib.diskoInstallerWrapper config { }).config.system.build.isoImage
        ) self.nixosConfigurations;

        homeConfigurations = {
          marcus = mkHMConfig { };
          aarch64 = mkHMConfig { system = "aarch64-linux"; };
        };
      };
      perSystem =
        { pkgs, system, ... }:
        {
          apps.default = {
            type = "app";
            program = "${hei.packages.${system}.default}/bin/hei";
          };
          devShells = {
            default = pkgs.mkShellNoCC {
              # nix flake show/check ignore allow-import-from-derivation from nix.conf
              NIX_CONFIG = ''
                experimental-features = nix-command flakes
                allow-import-from-derivation = true
              '';
              packages = with pkgs; [
                attic-client
                git
                go-task
                (inputs.clan-core.packages.${system}.clan-cli.override { nix = pkgs.nixVersions.latest; })
                inputs.hei.packages.${system}.default
                lolcat
                home-manager
                neovim
              ];
              shellHook = ''
                ${self.checks.${system}.pre-commit-check.shellHook}
                head -n 7 README.md|tail -n4|lolcat
              '';
            };
            update = pkgs.mkShellNoCC {
              NIX_CONFIG = "experimental-features = nix-command flakes";
              packages = with pkgs; [
                attic-client
                inputs.nix-fast-build.packages.${system}.default
              ];
            };
          };
          packages = {
            voyager = pkgs.callPackage ./packages/voyager { };
            riff-client = pkgs.callPackage ./packages/riff-client { };
          };
          checks = {
            home-manager =
              self.homeConfigurations.${
                if system == "x86_64-linux" then "marcus" else "aarch64"
              }.activationPackage;
            nixpkgs-prs =
              let
                results = import ./tests/nixpkgs-prs.nix {
                  inputs = originalInputs;
                  inherit system;
                };
              in
              assert builtins.all (result: result) (builtins.attrValues results);
              pkgs.runCommand "nixpkgs-prs-check" { } "touch $out";
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixfmt.enable = true;
                deadnix.enable = true;
                statix.enable = true;
              };
            };
          };
        };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    });

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    apple-silicon-support = {
      url = "github:marcusramberg/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    caddy-stack = {
      url = "https://code.bas.es/bases/caddy-stack/archive/main.tar.gz";
      # own nixpkgs: plugin vendor hash is tied to its caddy version
      inputs.flake-parts.follows = "flake-parts";
    };
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    dux-shell = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      # inputs.quickshell.follows = "quickshell";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:nix-community/flake-compat";
    hei = {
      url = "github:marcusramberg/hei";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "clan-core/treefmt-nix";
      };
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-small.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.zst";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    # quickshell.url = "github:quickshell-mirror/quickshell";
    # quickshell.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    theheck = {
      url = "https://code.bas.es/marcus/theheck/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        gomod2nix.follows = "hei/gomod2nix";
      };
    };
    unattended-installer = {
      url = "github:chrillefkr/nixos-unattended-installer";
      inputs = {
        disko.follows = "disko";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-pixel-9pro = {
      url = "git+https://code.bas.es/marcus/nixos-pixel-9pro.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    vanilla-mobile-nixos = {
      url = "github:marcusramberg/vanilla-mobile-nixos/marcus/fajita";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    android-translation-layer = {
      url = "git+https://code.bas.es/marcus/android-translation-layer.git?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.springchick.follows = "springchick";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    springchick = {
      url = "git+https://code.bas.es/marcus/springchick.git?ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-bpi-r4-pro = {
      url = "git+https://code.bas.es/marcus/nixos-bpi-r4-pro.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tee-fprintd = {
      url = "git+https://code.bas.es/marcus/tee-fprintd?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  aurora.url = "github:aurora-silicon/nixos-aurora/channel-testing";
    fjordxy = {
      url = "https://code.bas.es/bases/fjord/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
        home-manager.follows = "home-manager";
      };
    };
    ewm = {
      url = "git+https://codeberg.org/ezemtsov/ewm.git?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
