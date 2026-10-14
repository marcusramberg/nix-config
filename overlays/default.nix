inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
_: final: {

  charon = final.callPackage ../packages/charon { };
  cosmic-camera = final.callPackage ../packages/cosmic-camera { };
  enroll = final.callPackage ../packages/enroll { };
  plymouth-fjordxy = final.callPackage ../packages/plymouth-fjordxy { };
  gh-release-mono = final.callPackage ../packages/gh-release-mono { };
  gh-tidy = final.callPackage ../packages/gh-tidy { };
  riff = final.callPackage ../packages/riff-client { };
  tastiera = final.kdePackages.callPackage ../packages/tastiera { };
  tfenv = final.callPackage ../packages/tfenv { inherit inputs; };
  voyager = final.callPackage ../packages/voyager { };
}
