{
  description = "nix.means.no";

  outputs =
    {
      self,
      flake-parts,
      hei,
      ...

    }@inputs:
    with import ./lib { inherit inputs; };
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
          mtop = mkDesktopHost "mtop" { };
          mbench = mkNixHost "mbench" {
          };
          mdeck = mkDesktopHost "mdeck" {
            extraModules = [ inputs.jovian.nixosModules.default ];
          };
          mgate = mkNixHost "mgate" { };
          mlab = mkNixHost "mlab" { };
          mrack01 = mkNixHost "mrack01" { };
          mvirt = mkNixHost "mvirt" { };
          mpixel = mkNixHost "mpixel" {
            system = "aarch64-linux";
            extraModules = [ inputs.nixos-avf.nixosModules.avf ];
          };
        };
        specialArgs = { inherit inputs self; };
      };
      flake = {
        installers = builtins.mapAttrs (
          _: config:
          (inputs.unattended-installer.lib.diskoInstallerWrapper config { }).config.system.build.isoImage
        ) self.nixosConfigurations;

        darwinConfigurations.mwork = mkDarwinHost "mwork" { };
        darwinConfigurations.mStudio = mkDarwinHost "mstudio" { };
        homeConfigurations = {
          marcus = mkHMConfig { };
          aarch64 = mkHMConfig { system = "aarch64-linux"; };
          mac = mkHMConfig { system = "aarch64-darwin"; };
        };
      };
      perSystem =
        { pkgs, system, ... }:
        {
          apps.default = {
            type = "app";
            program = "${hei.packages.${system}.default}/bin/hei";
          };
          devShells.default = pkgs.mkShellNoCC {
            NIX_CONFIG = "experimental-features = nix-command flakes";
            packages = with pkgs; [
              attic-client
              git
              go-task
              inputs.clan-core.packages.${system}.clan-cli
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
          devShells.update = pkgs.mkShellNoCC {
            NIX_CONFIG = "experimental-features = nix-command flakes";
            packages = with pkgs; [
              attic-client
              inputs.nix-fast-build.packages.${system}.default
            ];
          };
          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixfmt-rfc-style.enable = true;
                deadnix.enable = true;
                statix.enable = true;
              };
            };
          };
        };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    });

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "github:nix-community/flake-compat";

    # System management
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Security and secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "darwin";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

    # Infrastructure
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unattended-installer = {
      url = "github:chrillefkr/nixos-unattended-installer";
      inputs = {
        disko.follows = "disko";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Development tools
    hei = {
      url = "github:marcusramberg/hei";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-fast-build.url = "github:Mic92/nix-fast-build";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    # Applications
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop environments
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell.url = "github:quickshell-mirror/quickshell";
    dank-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        quickshell.follows = "quickshell";
      };
    };

    # Hardware support
    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-avf = {
      url = "github:nix-community/nixos-avf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Services
    caddy-stack = {
      url = "https://code.bas.es/bas.es/caddy-stack/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-flake inputs
    tfenv = {
      url = "github:tfutils/tfenv";
      flake = false;
    };
  };
}
