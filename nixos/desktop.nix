{ config, pkgs, lib, ... }:
with lib;
let cfg = config.profiles.nimdow;
in {
  options.profiles.desktop.enable = mkEnableOption "desktop";

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
        zeal-qt6
      ] ++ lib.optionals (pkgs.system == "x86_64-linux") [
        pkgs.vivaldi-ffmpeg-codecs
        pkgs.discord
      ];

    profiles.myfonts.enable = true;

    qt.platformTheme = "gtk";

    services = {
      dbus.packages = [ pkgs.dconf ];

      openssh.settings.X11Forwarding = true;

      xserver = {
        enable = true;
        layout = "us";
        libinput.enable = true;
        xkbOptions = "eurosign:e";
        xkbVariant = "mac";
        displayManager = {
          sddm = {
            # greeters.gtk.enable = true;
            # greeters.gtk.theme.name = "Nordic";
            enable = true;
            wayland.enable = true;
          };
        };

        desktopManager.plasma5.enable = true;
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
