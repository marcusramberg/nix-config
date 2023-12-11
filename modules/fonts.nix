{ lib, config, pkgs, ... }:
with lib;
let cfg = config.profiles.myfonts;
in {
  options.profiles.myfonts = { enable = mkEnableOption "myfonts"; };
  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs;
        [
          liberation_ttf
          mplus-outline-fonts.githubRelease
          dina-font
          proggyfonts
          (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "Hack" ]; })
        ] ++ lib.optional stdenv.isLinux noto-fonts-emoji;
    };
  };
}
