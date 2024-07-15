{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    dagger.url = "github:dagger/nix";
    dagger.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
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
    # Do we actually use nur?
    nur.url = "github:nix-community/NUR";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    yaml2nix.url = "github:euank/yaml2nix";
    yaml2nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
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
        mbox = lib.mkNixHost "mbox" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
        mtop = lib.mkNixHost "mtop" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
        mvirt = lib.mkNixHost "mvirt" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
        mlab = lib.mkNixHost "mlab" {
          inherit
            overlays
            nixpkgs
            inputs
            std
            ;
          system = "x86_64-linux";
        };
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
        packages = {
          # mbrick-disk-image = inputs.self.nixosConfigurations.mbrick.config.mobile.outputs.default;
          # mbrick-boot-partition = inputs.self.nixosConfigurations.mbrick.config.mobile.outputs.u-boot-partion.default;
          homeConfigurations.marcus = lib.mkHMConfig { inherit inputs pkgs std; };
          homeConfigurations.deck = lib.mkHMConfig {
            inherit inputs pkgs std;
            user = "deck";
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            home-manager
            git
            neovim
          ];
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
      }
    );
}
