{
  description = "nimdow flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Makes the config pure as well. See <nixpkgs>/top-level/impure.nix:
          config = { allowBroken = true; };
        };
      in {
        devShell = pkgs.mkShell {
          name = "template-shell";
          buildInputs = with pkgs.nimPackages; [
            parsetoml
            x11
            safeset
            pkgs.st
            pkgs.dmenu
            pkgs.xorg.libX11
            pkgs.xorg.libXft
            pkgs.xorg.libXinerama
          ];
          nativeBuildInputs = with pkgs; [ nim ];
        };
        defaultPackage = pkgs.nimdow;
      });
}
