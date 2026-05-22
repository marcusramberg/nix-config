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
    rev = "6913b764a0bfa28d1f4dc05c0763d66093d858c5";
    hash = "sha256-pFU6lz5cc8rPrCJIDJWzcCZWVQ/x484R4pWDBTc8VMA=";
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
