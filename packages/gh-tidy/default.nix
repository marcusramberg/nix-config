{ pkgs, stdenvNoCC, lib, fetchgit }:
stdenvNoCC.mkDerivation {
  name = "gh-tidy";
  pname = "gh-tidy";
  src = fetchgit {
    url = "https://github.com/HaywardMorihara/gh-tidy.git";
    rev = "e43a55839ae62cec2715769b7b72b40b5d869119";
    hash = "sha256-BJtZZjs3xBjt6LC8VZSdVCmU1mcOnlDlMEW6Ck58S30=";
  };
  dontConfigure = true;
  dontBuild = true;
  buildInputs = [ pkgs.git ];

  installPhase = ''
    mkdir -p $out/bin
    cp gh-tidy $out/bin
  '';

  meta = with lib; {
    description = "A gh extension to tidy up your GitHub repositories";
    homepage = "https://github.com/HaywardMorihara/gh-tidy";
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
