{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/latest";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    hei.url = "github:marcusramberg/hei";
    hei.inputs.nixpkgs.follows = "nixpkgs";
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
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-std.url = "github:chessai/nix-std";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    webauthn-oidc.url = "github:arianvp/webauthn-oidc";
    webauthn-oidc.inputs.nixpkgs.follows = "nixpkgs";
    zig.url = "github:mitchellh/zig-overlay";

  };

  outputs = { nixpkgs, flake-utils, hei, nix-std, zig, ... }@inputs:
    let
      lib = import ./lib;
      overlays = [
        (import ./overlays inputs)
        (import ./overlays/caddy.nix inputs)
        inputs.emacs-overlay.overlay
        inputs.zig.overlays.default
      ];
      std = nix-std.lib;
    in with lib;
    {
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
        mgate = mkNixHost "mgate" {
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
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
        };
      in {
        apps.default = {
          type = "app";
          program = "${hei.packages.${system}.hei}/bin/hei";
        };
        packages = {
          mbrick-disk-image =
            inputs.self.nixosConfigurations.mbrick.config.mobile.outputs.default;
          # mbrick-boot-partition = inputs.self.nixosConfigurations.mbrick.config.mobile.outputs.u-boot-partion.default;
          homeConfigurations.marcus =
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit inputs std;
                osConfig = {
                  system = { };
                  networking = { hostName = ""; };
                };
              };

              modules = [

                ./home/default.nix
              ];
            };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ home-manager git ];
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
      });
}
