{
  nixpkgs,
  prs,
  system ? "x86_64-linux",
}:
let
  # Use an explicit build system so evaluation does not depend on currentSystem.
  pkgs = nixpkgs.legacyPackages.${system};
  source = pkgs.applyPatches {
    name = "nixpkgs-prs";
    src = nixpkgs.outPath;
    patches = map (
      { number, hash }:
      assert builtins.isInt number && number > 0;
      pkgs.fetchurl {
        name = "nixpkgs-pr-${toString number}.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/${toString number}.patch";
        inherit hash;
      }
    ) prs;
  };
  # Re-evaluate the flake against the patched tree: overriding pkgs alone would
  # leave nixosSystem, modulesPath, and the default NixOS modules unpatched.
  patched =
    nixpkgs
    // (import (source + "/flake.nix")).outputs { self = patched; }
    // {
      outPath = source;
    };
in
if prs == [ ] then nixpkgs else patched
