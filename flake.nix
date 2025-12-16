{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dagger.url = "github:dagger/nix";
    dagger.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    devenv.url = "github:cachix/devenv";
    disko.url = "github:nix-community/disko";
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
      deploy-rs,
      devenv,
      nixpkgs,
      flake-utils,
      hei,
      nix-std,
      ...
    }@inputs:
    let
      lib = import ./lib;
      overlays = [
        (import ./overlays inputs)
      ];
      std = nix-std.lib;

      # Common configuration for all hosts
      commonHostConfig = {
        inherit overlays nixpkgs inputs std;
      };

      # Helper to create a host with common config
      mkHost = name: system: extraConfig:
        lib.mkNixHost name (commonHostConfig // { inherit system; } // extraConfig);
    in
    {
      nixosConfigurations = {
        mhub = mkHost "mhub" "x86_64-linux" { };

        mhome = mkHost "mhome" "x86_64-linux" {
          extraModules = [ inputs.disko.nixosModules.disko ];
        };
        mhomeInstaller =
          inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mhome
            { };

        butterbee = mkHost "butterbee" "aarch64-linux" { };

        mstudio = mkHost "mstudio" "aarch64-linux" {
          extraModules = [
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
          ];
        };

        mcloud = mkHost "mcloud" "aarch64-linux" { };

        mbox = mkHost "mbox" "x86_64-linux" {
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        # mtop = mkHost "mtop" "x86_64-linux" { };
        # mvirt = mkHost "mvirt" "x86_64-linux" { };

        mbench = mkHost "mbench" "x86_64-linux" {
          extraModules = [ inputs.disko.nixosModules.disko ];
        };
        mbenchInstaller =
          inputs.unattended-installer.lib.diskoInstallerWrapper self.nixosConfigurations.mbench
            { };

        mdeck = mkHost "mdeck" "x86_64-linux" {
          extraModules = [ inputs.jovian.nixosModules.default ];
        };

        mgate = mkHost "mgate" "x86_64-linux" { };

        # mbrick = mkHost "mbrick" "aarch64-linux" {
        #   extraModules = [
        #     (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-fajita"; })
        #   ];
        # };
        # mOctopi = mkPiImage "moctopi" {
        #   inherit overlays nixpkgs inputs;
        #   system = "aarch64-linux";
        #   user = "marcus";
        # };
      };

      darwinConfigurations.mwork = lib.mkDarwinHost "mwork" {
        inherit overlays inputs std;
        system = "aarch64-darwin";
      };
      darwinConfigurations.mStudio = lib.mkDarwinHost "mstudio" {
        inherit overlays inputs std;
        system = "aarch64-darwin";
        remoteBuild = true;
      };
      deploy.nodes = with inputs.deploy-rs.lib; {
        mcloud = {
          hostname = "mcloud";
          sshUser = "marcus";
          user = "root";
          fastConnection = false;
          profiles.system.path = aarch64-linux.activate.nixos inputs.self.nixosConfigurations.mcloud;
          remoteBuild = true;
        };
        mhub = {
          hostname = "mhub";
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          activationTimeout = 600; # mhub is slow to activate
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mhub;
        };
        mstudio = {
          hostname = "mstudio";
          remoteBuild = true;
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mstudio;
        };
        mgate = {
          hostname = "mgate";
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mgate;
        };
        mbox = {
          hostname = "mbox";
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mbox;
        };
        mhome = {
          hostname = "mhome";
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mhome;
        };
      };
      # checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
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
        homeConfigurations.marcus = lib.mkHMConfig { inherit inputs pkgs std; };
        packages.devenv-up = self.devShells.${system}.default.config.procfileScript;
        packages.devenv-test = self.devShells.${system}.default.config.test;
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            (
              { pkgs, ... }:
              {

                name = "nix-config";
                cachix.pull = [
                  "nix-community"
                  "marcusramberg"
                ];
                env.NIX_CONFIG = "experimental-features = nix-command flakes";
                languages.lua = {
                  enable = true;
                };
                languages.nix = {
                  enable = true;
                };
                packages = with pkgs; [
                  pkgs.deploy-rs
                  pkgs.devenv
                  git
                  lolcat
                  neovim
                  home-manager
                  neovim
                ];
                pre-commit.hooks = {
                  commitizen.enable = true;
                  deadnix.enable = true;
                  # luacheck.enable = true;
                  markdownlint.enable = true;
                  nixfmt-rfc-style.enable = true;
                  statix.enable = true;
                  stylua.enable = true;
                  yamllint.enable = true;
                };
                enterShell = ''
                  head -n 7 README.md|tail -n4|lolcat
                '';
                enterTest = ''
                  nix flake metadata
                '';
              }
            )
          ];
        };
      }
    );
}
