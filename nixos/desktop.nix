{ config, pkgs, lib, ... }:
with lib;
let cfg = config.profiles.nimdow;
in {
  options.profiles.nimdow.enable = mkEnableOption "nimdow";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        copyq
        element-desktop
        feh
        neovide
        nitrogen
        obsidian
        pavucontrol
        picom
        nordic
        rofi
        telegram-desktop
        vivaldi
        volumeicon
        xarchiver
        xclip
      ] ++ lib.optionals (pkgs.system == "x86_64-linux") [
        pkgs.vivaldi-ffmpeg-codecs
        pkgs.discord
      ];

    profiles.myfonts.enable = true;

    qt.platformTheme = "gtk";

    services = {
      dbus.packages = [ pkgs.dconf ];

      openssh.settings.X11Forwarding = true;

      picom = {
        enable = true;
        activeOpacity = 1;
        vSync = true;
        backend = "glx";
      };

      xserver = {
        enable = true;
        layout = "us";
        libinput.enable = true;
        xkbOptions = "eurosign:e";
        xkbVariant = "mac";
        displayManager = {
          defaultSession = "xfce+nimdow";
          lightdm = {
            greeters.gtk.enable = true;
            greeters.gtk.theme.name = "Nordic";
            enable = true;
          };
        };

        desktopManager = {
          plasma5.enable = true;
          xfce = {
            enable = true;
            noDesktop = true;
            enableXfwm = false;
          };
        };
        windowManager.nimdow.enable = true;
      };
      xrdp.enable = true;
    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
    xdg.mime.defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };
    environment.sessionVariables.DEFAULT_BROWSER =
      "${pkgs.vivaldi}/bin/vivaldi";
  };
}