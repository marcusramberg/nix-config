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
  options.profiles.limine = {
    enable = lib.mkEnableOption "Limine bootloader";
    secureboot = lib.mkEnableOption "Secureboot";
    interface_rotation = lib.mkOption {
      type = lib.types.enum [
        "0"
        "90"
        "180"
        "270"
      ];
      default = "0";
      description = ''
        Rotation of the Limine interface. This is useful for devices with rotated
        screens, such as the Steam Deck.
      '';
    };
    font_scale = lib.mkOption {
      type = lib.types.str;
      default = "3x3";
      description = ''
        Font scale for the graphical terminal. Limine falls back to the UEFI
        text console when the resulting grid is smaller than 40x16, so use a
        smaller scale on low-resolution screens like the Steam Deck.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      limine = {
        enable = true;
        maxGenerations = 4;
        secureBoot.enable = cfg.secureboot;
        extraConfig = ''
          interface_rotation: ${cfg.interface_rotation}
        '';
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
            font.scale = cfg.font_scale;
          };
        };
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
