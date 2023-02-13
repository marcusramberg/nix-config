tfenv:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit tfenv;
in
self: super: {

  # wezterm-bin = super.callPackage ../packages/wezterm-bin { };
  # wezterm-nightly = super.callPackage ../packages/wezterm-nightly { };

  # forgit = super.callPackage ../packages/forgit { inputs = inputs; };
  tfenv = super.callPackage ../packages/tfenv { tfenv = tfenv; };
}


