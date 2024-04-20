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

      displayManager.defaultSession = "xfce+nimdow";
      xserver = {
        desktopManager.xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
        windowManager.nimdow.enable = true;
        # windowManager.nimdow.package = pkgs.nimdow.overrideAttrs (old: {
        #   src.rev = "v1.4.8";
        #   src.hash = lib.fakeHash;
        # });
      };
    };
  };
}
