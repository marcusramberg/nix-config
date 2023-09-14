{
  description = "nix.means.no";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    devenv.url = "github:cachix/devenv/latest";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hei.url = "github:marcusramberg/hei";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    mobile-nixos.flake = false;
    mobile-nixos.url = "github:marcusramberg/mobile-nixos/enchilada";
    neovim-nightly-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    webauthn-oidc.url = "github:arianvp/webauthn-oidc";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      defaultUserName = "marcus";
      mkNixHost = import lib/mkNixHost.nix;
      # mkPiImage = import lib/mkNixHost.nix;
      mkDarwinHost = import lib/mkDarwinHost.nix;
      overlays = [
        (import ./overlays inputs)
        (import ./overlays/caddy.nix inputs)
        # inputs.neovim-nightly-overlay.overlay
        inputs.emacs-overlay.overlay
      ];
    in {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = defaultUserName;
        };
        butterbee = mkNixHost "butterbee" {
          inherit overlays nixpkgs inputs;
          system = "aarch64-linux";
          user = defaultUserName;
        };
        mbox = mkNixHost "mbox" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = defaultUserName;
        };
        mtop = mkNixHost "mtop" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = defaultUserName;
        };
        mlab = mkNixHost "mlab" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = defaultUserName;
        };
        mbrick = mkNixHost "mbrick" {
          inherit overlays nixpkgs inputs;
          system = "aarch64-linux";
          user = defaultUserName;
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

      darwinConfigurations.mbook = mkDarwinHost {
        inherit overlays inputs;
        system = "aarch64-darwin";
        user = "marcus";
      };
    };
}
