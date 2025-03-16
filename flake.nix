{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon-support = {
      url = "github:flokli/nixos-apple-silicon/linux-6.13";
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
    # mobile-nixos = {
    #   flake = false;
    #   url = "github:marcusramberg/mobile-nixos/enchilada";
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
      nixosConfigurations = inputs.self.colmenaHive.nodes;
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = {
            inherit inputs;
            user = "marcus";
          };
        };

        mhub = mkNixHost "mhub" {
          inherit
            overlays
            inputs
            ;
          system = "x86_64-linux";
        };

        mhome = mkNixHost "mhome" {
          inherit
            overlays
            inputs
            ;
          extraModules = [ inputs.disko.nixosModules.disko ];
          system = "x86_64-linux";
        };
        mhomeInstaller =
          inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mhome
            { };
        butterbee = mkNixHost "butterbee" {
          inherit
            overlays
            inputs
            ;
          system = "aarch64-linux";
        };
        mstudio = mkNixHost "mstudio" {
          inherit
            overlays
            inputs
            ;
          system = "aarch64-linux";
          extraModules = [
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
          ];
        };
        mcloud = mkNixHost "mcloud" {
          inherit
            overlays
            inputs
            ;
          system = "aarch64-linux";
        };

        mbox = mkNixHost "mbox" {
          inherit
            overlays
            inputs
            ;
          system = "x86_64-linux";
          deployment = {
            tags = [ "k8s" ];
            allowLocalDeployment = true;
          };
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        mbench = mkNixHost "mbench" {
          inherit
            overlays
            inputs
            ;
          system = "x86_64-linux";
          extraModules = [ inputs.disko.nixosModules.disko ];
        };
        mbenchInstaller =
          inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mbench
            { };
        mdeck = mkNixHost "mdeck" {
          inherit
            overlays
            inputs
            ;
          system = "x86_64-linux";
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        mgate = mkNixHost "mgate" {
          inherit
            overlays
            inputs
            ;
          system = "x86_64-linux";
        };
      };

      darwinConfigurations.mwork = mkDarwinHost "mwork" {
        inherit overlays inputs;
        system = "aarch64-darwin";
      };
      darwinConfigurations.mStudio = mkDarwinHost "mstudio" {
        inherit overlays inputs;
        system = "aarch64-darwin";
        remoteBuild = true;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system overlays;
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
          program = "${hei.packages.${system}.hei}/bin/hei";
        };
        homeConfigurations.marcus = lib.mkHMConfig { inherit inputs pkgs; };
        devShells.default = pkgs.mkShellNoCC {
          NIX_CONFIG = "experimental-features = nix-command flakes";
          packages = with pkgs; [
            colmena.packages.${system}.colmena
            git
            lolcat
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
