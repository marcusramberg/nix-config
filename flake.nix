{
  description = "nix.means.no";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "darwin";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };
    authentik.url = "github:nix-community/authentik-nix";
    apple-silicon-support = {
      url = "github:schphe/nixos-apple-silicon";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };
    dagger.url = "github:dagger/nix";
    dagger.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:nix-community/flake-compat";
    hei = {
      url = "github:marcusramberg/hei";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # microvm = {
    #   url = "github:astro/microvm.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-std.url = "github:chessai/nix-std";
    nix-converter = {
      url = "github:theobori/nix-converter";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    systems.url = "github:nix-systems/default";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    unattended-installer = {
      url = "github:chrillefkr/nixos-unattended-installer";
      inputs = {
        disko.follows = "disko";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      colmena,
      nixpkgs,
      flake-utils,
      hei,
      ...
    }@inputs:
    with import ./lib {
      inherit inputs;
      patches =
        f: with f; {
          nixpkgs = [
            # kio-admin fix
            (npr 394641 "foobar")
          ];
        };

    };
    {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
          extraModules = [ inputs.authentik.nixosModules.default ];
        };
        mhome = mkNixHost "mhome" {
          extraModules = [ inputs.disko.nixosModules.disko ];
        };
        butterbee = mkNixHost "butterbee" {
          system = "aarch64-linux";
        };
        mstudio = mkNixHost "mstudio" {
          system = "aarch64-linux";
          extraModules = [
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
          ];
        };
        mbox = mkNixHost "mbox" {
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        mbench = mkNixHost "mbench" {
          extraModules = [ inputs.disko.nixosModules.disko ];
        };
        mdeck = mkNixHost "mdeck" {
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        mrack01 = mkNixHost "mrack01" {
          extraModules = [ inputs.disko.nixosModules.default ];
        };
        mvm = mkNixHost "mvm" {
          extraModules = [ "${inputs.nixpkgs}/nixos/modules/virtualisation/lxd-virtual-machine.nix" ];
        };
      };
      installers = builtins.mapAttrs (
        _: config:
        (inputs.unattended-installer.lib.diskoInstallerWrapper config { }).config.system.build.isoImage
      ) self.nixosConfigurations;

      colmenaHive = mkColmenaHive inputs.nixpkgs.legacyPackages.x86_64-linux {

        mhub.tags = [
          "k8s"
          "servers"
        ];
        mhome.tags = [
          "servers"
          "kodi"
        ];
        butterbee.buildOnTarget = true;
        mstudio = {
          tags = [
            "k8s"
            "servers"
          ];
          buildOnTarget = true;
        };
        mbox.tags = [
          "k8s"
          "servers"
        ];
        mbench.tags = [
          "servers"
          "kodi"
        ];
        mgate.tags = [ "servers" ];
        mrack01.tags = [ "servers" ];
      };

      darwinConfigurations.mwork = mkDarwinHost "mwork" { };
      darwinConfigurations.mStudio = mkDarwinHost "mstudio" { };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        apps.default = {
          type = "app";
          program = "${hei.packages.${system}.default}/bin/hei";
        };
        devShells.default = pkgs.mkShellNoCC {
          NIX_CONFIG = "experimental-features = nix-command flakes";
          packages = with pkgs; [
            colmena.packages.${system}.colmena
            git
            lolcat
            go-task
            neovim
            home-manager
            neovim
          ];
          shellHook = ''
            head -n 7 README.md|tail -n4|lolcat
          '';
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

      }
    )
    // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system: {
      homeConfigurations.marcus = lib.mkHMConfig { inherit system; };
    });
}
