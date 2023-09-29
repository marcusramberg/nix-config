{ pkgs, stdenvNoCC, lib, fetchgit }:
stdenvNoCC.mkDerivation {
  name = "gh-tidy";
  pname = "gh-tidy";
  src = fetchgit {
    url = "https://github.com/HaywardMorihara/gh-tidy.git";
    rev = "7397d40e293a001fddf47f985c634dd941f1f55";
    sha256 = "sha256-Bi/0+1HP2zLoYvShuUIc7DaCQawU3MmDg/xHDA5nveA=";
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
