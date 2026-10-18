{
  stdenvNoCC,
  lib,
  nixos-icons,
  librsvg,
  imagemagick,
  jetbrains-mono,
}:
stdenvNoCC.mkDerivation {
  pname = "limine-nixos";
  version = "0.1";
  src = ../plymouth-nixos/theme;
  nativeBuildInputs = [
    librsvg
    imagemagick
  ];

  # Same palette as plymouth-nixos: bg #040509, cyan #2ef0ff, magenta #ff2d87.
  # Logo sits in the top third so the boot menu below stays readable.
  installPhase = ''
    mkdir -p $out
    rsvg-convert -w 300 -h 300 ${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg -o base.png
    magick -size 1920x1200 xc:'#040509' bg.png
    magick base.png -fill '#ff2d87' -colorize 100 b.png
    magick base.png -fill '#2ef0ff' -colorize 100 a.png
    magick base.png \( +clone -fill '#2ef0ff' -colorize 100 -blur 0x18 \) -compose dst-over -composite w.png
    magick -background none -fill '#2ef0ff' -font ${jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf \
      -pointsize 22 -kerning 9 label:'DECLARE // BUILD // BOOT' -trim tagline.png
    magick bg.png \
      overlay.png -resize 1920x1200! -compose over -composite \
      b.png -geometry +816+150 -compose over -composite \
      a.png -geometry +804+150 -compose over -composite \
      w.png -geometry +810+150 -compose over -composite \
      tagline.png -gravity north -geometry +0+470 -composite \
      corner.png -gravity northwest -geometry +40+40 -composite \
      \( corner.png -rotate 90 \) -gravity northeast -geometry +40+40 -composite \
      \( corner.png -rotate -90 \) -gravity southwest -geometry +40+40 -composite \
      \( corner.png -rotate 180 \) -gravity southeast -geometry +40+40 -composite \
      $out/wallpaper.png
  '';

  meta = {
    description = "Limine wallpaper matching the plymouth-nixos cyberpunk theme";
    platforms = lib.platforms.linux;
  };
}
