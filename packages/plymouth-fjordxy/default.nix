{ stdenvNoCC, lib }:
stdenvNoCC.mkDerivation {
  pname = "plymouth-fjordxy";
  version = "0.1";
  src = ./theme;

  installPhase = ''
    dir=$out/share/plymouth/themes/fjordxy
    mkdir -p $dir
    cp *.png fjordxy.script fjordxy.plymouth $dir/
    substituteInPlace $dir/fjordxy.plymouth --replace-fail /usr/share $out/share
  '';

  meta = {
    description = "Cyberpunk neon-glitch Plymouth boot splash";
    platforms = lib.platforms.linux;
  };
}
