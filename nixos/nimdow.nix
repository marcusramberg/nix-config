{ config, pkgs, lib, ... }:
with lib;
let cfg = config.profiles.nimdow;
in {
  options.profiles.nimdow.enable = mkEnableOption "nimdow";

  config = mkIf cfg.enable {

    profiles.desktop.enable = true;

    qt.platformTheme = "gtk2";

    services = {
      dbus.packages = [ pkgs.dconf ];

      picom = {
        enable = true;
        activeOpacity = 1;
        vSync = true;
        backend = "glx";
      };

      xserver = {
        displayManager.defaultSession = "xfce+nimdow";

        desktopManager.xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
        windowManager.nimdow.enable = true;
      };
    };
  };
}
