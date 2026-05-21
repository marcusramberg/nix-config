inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
_: super: {

  gh-tidy = super.callPackage ../packages/gh-tidy { };
  gh-release-mono = super.callPackage ../packages/gh-release-mono { };
  tfenv = super.callPackage ../packages/tfenv { inherit inputs; };
}
