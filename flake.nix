{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/latest";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hei.url = "github:marcusramberg/hei";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      flake = false;
      url = "github:marcusramberg/mobile-nixos/enchilada";
    };
    nix-std.url = "github:chessai/nix-std";
    neovim-nightly-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    webauthn-oidc.url = "github:arianvp/webauthn-oidc";
  };

  outputs = { nixpkgs, flake-utils, hei, nix-std, ... }@inputs:
    let
      mkNixHost = import lib/mkNixHost.nix;
      # mkPiImage = import lib/mkNixHost.nix;
      mkDarwinHost = import lib/mkDarwinHost.nix;
      overlays = [
        (import ./overlays inputs)
        (import ./overlays/caddy.nix inputs)
        # inputs.neovim-nightly-overlay.overlay
        inputs.emacs-overlay.overlay
      ];
      std = nix-std.lib;
    in {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
          inherit overlays nixpkgs inputs std;
          system = "x86_64-linux";
        };
        butterbee = mkNixHost "butterbee" {
          inherit overlays nixpkgs inputs std;
          system = "aarch64-linux";
        };
        mbox = mkNixHost "mbox" {
          inherit overlays nixpkgs inputs std;
          system = "x86_64-linux";
        };
        mtop = mkNixHost "mtop" {
          inherit overlays nixpkgs inputs std;
          system = "x86_64-linux";
        };
        mvirt = mkNixHost "mvirt" {
          inherit overlays nixpkgs inputs std;
          system = "x86_64-linux";
        };
        mlab = mkNixHost "mlab" {
          inherit overlays nixpkgs inputs std;
          system = "x86_64-linux";
        };
        mbrick = mkNixHost "mbrick" {
          inherit overlays nixpkgs inputs std;
          system = "aarch64-linux";
          extraModules = [
            (import "${inputs.mobile-nixos}/lib/configuration.nix" {
              device = "oneplus-fajita";
            })
          ];
        };
        # mOctopi = mkPiImage "moctopi" {
        #   inherit overlays nixpkgs inputs;
        #   system = "aarch64-linux";
        #   user = "marcus";
        # };
      };

      darwinConfigurations.mwork = mkDarwinHost {
        inherit overlays inputs std;
        system = "aarch64-darwin";
      };
    } // flake-utils.lib.eachDefaultSystem (system: {
      apps.default = {
        type = "app";
        program = "${hei.packages.${system}.hei}/bin/hei";

      };
    });
}
