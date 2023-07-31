inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in pkgs: super: {

  # wezterm-bin = super.callPackage ../packages/wezterm-bin { };
  # wezterm-nightly = super.callPackage ../packages/wezterm-nightly { };

  # forgit = super.callPackage ../packages/forgit { inputs = inputs; };
  tfenv = super.callPackage ../packages/tfenv { inherit inputs; };
  wezterm-nightly = super.callPackage ../packages/wezterm-nightly { };
  nimdow = super.nimdow.overrideAttrs (oldAttrs: rec {
    patches = oldAttrs.patches or [ ] ++ [ ./patches/nimdow-randr.patch ];
  });
  nzbget = super.nzbget.overrideAttrs (oa: {
    pname = "nzbget-ng";
    version = "21.4-rc1";
    src = pkgs.fetchurl {
      url =
        "https://github.com/nzbget-ng/nzbget/archive/refs/tags/v21.4-rc1.tar.gz";
      hash = "sha256-3zOJen/OzxUtWPtwX2HzLfn2+SpFuvnkH/KbojFGgWg=";
    };
    patches = [ ];
    prePatch = ''
      sed -i 's/AC_INIT.*/AC_INIT( nzbget, m4_esyscmd_s( echo 21.4-rc1 ) )/' configure.ac
    '';
    buildInputs = [ pkgs.libcap ] ++ oa.buildInputs;
    nativeBuildInputs = [ pkgs.autoreconfHook ] ++ oa.nativeBuildInputs;
  });
}

