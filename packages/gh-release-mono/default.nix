{
  pkgs,
  stdenvNoCC,
  lib,
  fetchgit,
}:
stdenvNoCC.mkDerivation {
  name = "gh-release-mono";
  pname = "gh-release-mono";
  src = fetchgit {
    url = "https://github.com/marcusramberg/gh-release-mono";
    rev = "140f3120c4ac2d59188f9ffb6c30741f15ef5c3d";
    hash = "sha256-g8XJxkRGeWTBb3WRncU/C6JXI13JHiqnZP0MwbWrssc=";
  };
  dontConfigure = true;
  dontBuild = true;
  buildInputs = [ pkgs.git ];

  installPhase = ''
    mkdir -p $out/bin
    cp gh-release-mono $out/bin
  '';

  meta = with lib; {
    description = "A gh extension to simplify monorepo releases";
    homepage = "https://github.com/marcusramberg/gh-release-mono";
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
