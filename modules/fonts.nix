{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.myfonts;
in
{
  options.profiles.myfonts = {
    enable = mkEnableOption "myfonts";
  };
  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        dina-font
        eb-garamond
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        proggyfonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.hack
        roboto
        roboto-serif
        noto-fonts-color-emoji
      ];
    };
  };
}
