inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
_: final: {

  gh-tidy = final.callPackage ../packages/gh-tidy { };
  gh-release-mono = final.callPackage ../packages/gh-release-mono { };
  tfenv = final.callPackage ../packages/tfenv { inherit inputs; };
  cosmic-camera = final.callPackage ../ackages/cosmic-camera { };
  charon = final.callPackage ../packages/charon { };
  enroll = final.callPackage ../packages/enroll { };
  riff = final.callPackage ../packages/riff-client { };
  voyager = final.callPackage ../packages/voyager { };
}
