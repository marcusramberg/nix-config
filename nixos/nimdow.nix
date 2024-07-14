{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.nimdow;
in
{
  options.profiles.nimdow.enable = lib.mkEnableOption "nimdow";

  config = lib.mkIf cfg.enable {

    profiles.desktop.enable = true;

    # qt.platformTheme = "gtk2";

    services = {
      dbus.packages = [ pkgs.dconf ];

      picom = {
        enable = true;
        activeOpacity = 1;
        vSync = true;
        backend = "glx";
      };

      displayManager.defaultSession = lib.mkDefault "xfce+nimdow";
      xserver.windowManager.nimdow.enable = true;
    };
  };
}
