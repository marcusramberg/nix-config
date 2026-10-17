{
  stdenvNoCC,
  lib,
  nixos-icons,
  librsvg,
  imagemagick,
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-nixos";
  version = "0.1";
  src = ./theme;
  nativeBuildInputs = [
    librsvg
    imagemagick
  ];

  installPhase = ''
    dir=$out/share/plymouth/themes/nixos
    mkdir -p $dir
    cp *.png nixos.script nixos.plymouth $dir/
    substituteInPlace $dir/nixos.plymouth --replace-fail /usr/share $out/share

    rsvg-convert -w 420 -h 420 ${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg -o base.png
    pad="-background none -gravity center -extent 500x500"
    magick base.png \( +clone -fill '#2ef0ff' -colorize 100 -blur 0x14 \) -compose dst-over -composite $pad $dir/logo.png
    magick base.png -fill '#2ef0ff' -colorize 100 $pad $dir/logo-a.png
    magick base.png -fill '#ff2d87' -colorize 100 $pad $dir/logo-b.png
  '';

  meta = {
    description = "Cyberpunk neon-glitch Plymouth boot splash with the NixOS logo";
    platforms = lib.platforms.linux;
  };
}
