inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
_: final: {

  charon = final.callPackage ../packages/charon { };
  cosmic-camera = final.callPackage ../packages/cosmic-camera { };
  plymouth-fjordxy = final.callPackage ../packages/plymouth-fjordxy { };
  plymouth-nixos = final.callPackage ../packages/plymouth-nixos { };
  limine-nixos = final.callPackage ../packages/limine-nixos { };
  gh-release-mono = final.callPackage ../packages/gh-release-mono { };
  gh-tidy = final.callPackage ../packages/gh-tidy { };
  hassmote = final.callPackage ../packages/hassmote { };
  nfc-badge = final.callPackage ../packages/nfc-badge { };
  riff = final.callPackage ../packages/riff-client { };
  stoandl = final.callPackage ../packages/stoandl { };
  stoandl-gui = final.kdePackages.callPackage ../packages/stoandl-gui { };
  tastiera = final.kdePackages.callPackage ../packages/tastiera { };
  tfenv = final.callPackage ../packages/tfenv { inherit inputs; };
  voyager = final.callPackage ../packages/voyager { };
}
