inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
pkgs: super: {

  gh-tidy = super.callPackage ../packages/gh-tidy { };

  # forgit = super.callPackage ../packages/forgit { inputs = inputs; };
  tfenv = super.callPackage ../packages/tfenv { inherit inputs; };
  wezterm-nightly = super.callPackage ../packages/wezterm-nightly { };
  nzbget = super.nzbget.overrideAttrs (oa: {
    pname = "nzbget-ng";
    version = "21.4-rc2";
    src = pkgs.fetchurl {
      url = "https://github.com/nzbget-ng/nzbget/archive/refs/tags/v21.4-rc2.tar.gz";
      hash = "sha256-l2gWl6BW/a4vmbEoXpA1NQkcLi33B0xnC1XKtj216e0=";
    };
    patches = [ ];
    prePatch = ''
      sed -i 's/AC_INIT.*/AC_INIT( nzbget, m4_esyscmd_s( echo 21.4-rc1 ) )/' configure.ac
    '';
    buildInputs = [ pkgs.libcap ] ++ oa.buildInputs;
    nativeBuildInputs = [ pkgs.autoreconfHook ] ++ oa.nativeBuildInputs;
  });

}
