{
  description = "nix.means.no";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-wsl.url = "github:nix-community/NixOS-WSL";
    devenv.url = "github:cachix/devenv/latest";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";
    webauthn-oidc.url = "github:arianvp/webauthn-oidc";

    tfenv.url = "github:tfutils/tfenv";
    tfenv.flake = false;
    mobile-nixos.url = "github:marcusramberg/mobile-nixos/enchilada";
    mobile-nixos.flake = false;
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      defaultUserName = "marcus";
      mkNixHost = import lib/mkNixHost.nix;
      mkMobileNixHost = import lib/mkMobileNixHost.nix;
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
        mbrick = mkMobileNixHost "mbrick" {
          inherit overlays nixpkgs inputs;
          system = "aarch64-linux";
          user = defaultUserName;
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
