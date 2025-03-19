{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs";
        # nix-github-actions.follows = "nix-github-actions";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };
    dagger.url = "github:dagger/nix";
    dagger.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    flake-compat = {
      url = "github:nix-community/flake-compat";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hei.url = "github:marcusramberg/hei";
    hei.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    # microvm = {
    #   url = "github:astro/microvm.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-std.url = "github:chessai/nix-std";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    unattended-installer.url = "github:chrillefkr/nixos-unattended-installer";
    yaml2nix.url = "github:euank/yaml2nix";
    yaml2nix.inputs.nixpkgs.follows = "nixpkgs";
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
    };
    {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
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
        mcloud = mkNixHost "mcloud" {
          system = "aarch64-linux";
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

      };
      installers = builtins.mapAttrs (
        _: config: (inputs.unattended-installer.lib.diskoInstallerWrapper config { })
      ) self.nixosConfigurations;
      #   mhomeInstaller =
      #     inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mhome
      #       { };
      #   mbenchInstaller =
      #     inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mbench
      #       { };
      # };

      colmenaHive = mkColmenaHive inputs.nixpkgs.legacyPackages.x86_64-linux {

        mhub.tags = [
          "k8s"
          "servers"
        ];
        mhome.tags = [ "servers" ];
        butterbee.buildOnTarget = true;
        mstudio = {
          tags = [
            "k8s"
            "servers"
          ];
          buildOnTarget = true;
        };
        mcloud.tags = [ "servers" ];
        mbox.tags = [
          "k8s"
          "servers"
        ];
        mbench.tags = [ "servers" ];
        mgate.tags = [ "servers" ];
      };

      darwinConfigurations.mwork = mkDarwinHost "mwork" { };
      darwinConfigurations.mStudio = mkDarwinHost "mstudio" { };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
        };
      in
      {
        apps.default = {
          type = "app";
          program = "${inputs.hei.packages.${system}.default}/bin/hei";
        };
        homeConfigurations.marcus = lib.mkHMConfig { inherit inputs pkgs; };
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
    );
}
