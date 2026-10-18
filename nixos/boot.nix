{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.limine;
in
{
  options.profiles.limine.enable = lib.mkEnableOption "Limine bootloader";
  options.profiles.limine.secureboot = lib.mkEnableOption "Secureboot";

  config = lib.mkIf cfg.enable {
    boot.loader = {
      limine = {
        enable = true;
        maxGenerations = 4;
        secureBoot.enable = cfg.secureboot;
        # Colours match packages/plymouth-nixos
        style = {
          wallpapers = [ "${pkgs.limine-nixos}/wallpaper.png" ];
          wallpaperStyle = "stretched";
          backdrop = "040509";
          interface = {
            branding = "if found, please return to Marcus Ramberg - 94357747";
            brandingColor = "ff2d87";
            helpColor = "2ef0ff";
            helpColorBright = "7ff6ff";
            resolution = "1920x1200";
          };
          graphicalTerminal = {
            palette = "040509;ff2d87;2ef0ff;ffe14d;2ef0ff;ff2d87;2ef0ff;ebfdff";
            brightPalette = "1a1d2e;ff5da3;7ff6ff;fff07a;7ff6ff;ff5da3;7ff6ff;ffffff";
            foreground = "ebfdff";
            background = "040509";
            brightForeground = "ffffff";
            brightBackground = "1a1d2e";
            font.scale = "3x3";
          };
        };
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
