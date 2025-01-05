{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    apple-silicon-support = {
      #url = "github:marcusramberg/nixos-apple-silicon/kernel_bump";
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
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cachix.inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    hei.url = "github:marcusramberg/hei";
    hei.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
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
    # Do we actually use nur?
    nur.url = "github:nix-community/NUR";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    yaml2nix.url = "github:euank/yaml2nix";
    yaml2nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      deploy-rs,
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
        (import ./overlays/caddy.nix inputs)
      ];
      std = nix-std.lib;
    in
    {
      nixosConfigurations = {
        mhub = lib.mkNixHost "mhub" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
        butterbee = lib.mkNixHost "butterbee" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "aarch64-linux";
        };
        mstudio = lib.mkNixHost "mstudio" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "aarch64-linux";
          extraModules = [
            inputs.apple-silicon-support.nixosModules.apple-silicon-support
          ];
        };
        mcloud = lib.mkNixHost "mcloud" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "aarch64-linux";
        };

        mbox = lib.mkNixHost "mbox" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        # mtop = lib.mkNixHost "mtop" {
        #   inherit
        #     overlays
        #     nixpkgs
        #     inputs
        #     std
        #     ;
        #   system = "x86_64-linux";
        # };
        # mvirt = lib.mkNixHost "mvirt" {
        #   inherit
        #     overlays
        #     nixpkgs
        #     inputs
        #     std
        #     ;
        #   system = "x86_64-linux";
        # };
        # mlab = lib.mkNixHost "mlab" {
        #   inherit
        #     overlays
        #     nixpkgs
        #     inputs
        #     std
        #     ;
        #   system = "x86_64-linux";
        # };
        mdeck = lib.mkNixHost "mdeck" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
          extraModules = [ inputs.jovian.nixosModules.default ];
        };
        mgate = lib.mkNixHost "mgate" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
        # mbrick = lib.mkNixHost "mbrick" {
        #   inherit
        #     overlays
        #     nixpkgs
        #     inputs
        #     std
        #     ;
        #   system = "aarch64-linux";
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

      darwinConfigurations.mwork = lib.mkDarwinHost {
        inherit overlays inputs std;
        system = "aarch64-darwin";
      };
      deploy.nodes = with inputs.deploy-rs.lib; {
        mcloud = {
          hostname = "mcloud";
          sshUser = "marcus";
          user = "root";
          fastConnection = false;
          profiles.system.path = aarch64-linux.activate.nixos inputs.self.nixosConfigurations.mcloud;
        };
        mhub = {
          hostname = "mhub";
          sshUser = "marcus";
          user = "root";
          fastConnection = true;
          profiles.system.path = x86_64-linux.activate.nixos inputs.self.nixosConfigurations.mhub;
        };
      };
      checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            home-manager
            git
            neovim
            deploy-rs.packages.x86_64-linux.deploy-rs
          ];
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
      }
    );
}
