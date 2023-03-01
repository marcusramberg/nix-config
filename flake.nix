{
  description = "nix.means.no";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stable.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    devenv.url = "github:cachix/devenv/latest";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    agenix.url = "github:ryantm/agenix";

    tfenv.url = "github:tfutils/tfenv";
    tfenv.flake = false;
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      mkNixHost = import lib/mkNixHost.nix;
      mkDarwinHost = import lib/mkDarwinHost.nix;
      localOverlays = import ./overlays inputs;
      overlays = [ localOverlays inputs.neovim-nightly-overlay.overlay ];
    in {
      nixosConfigurations = {
        mhub = mkNixHost "mhub" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = "marcus";
        };
        butterbee = mkNixHost "butterbee" {
          inherit overlays nixpkgs inputs;
          system = "aarch64-linux";
          user = "marcus";
        };
        mbox = mkNixHost "mbox" {
          inherit overlays nixpkgs inputs;
          system = "x86_64-linux";
          user = "marcus";
        };
      };

      darwinConfigurations.mbook = mkDarwinHost "mbook" {
        inherit overlays inputs;
        system = "aarch64-darwin";
        user = "marcus";
      };
    };
}
