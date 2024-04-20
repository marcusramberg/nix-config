{ config, pkgs, lib, ... }:
with lib;
let cfg = config.profiles.desktop;
in {
  options.profiles.desktop.enable = mkEnableOption "desktop";

  config = mkIf cfg.enable {

    # Enable plymouth
    boot = {
      initrd.systemd.enable =
        true; # This is needed to show the plymouth login screen to unlock luks
      plymouth = {
        enable = true;
        theme = "breeze";
      };
    };

    environment.systemPackages = with pkgs;
      [
        bitwarden
        copyq
        element-desktop
        feh
        flameshot
        # kotatogram-desktop
        neovide
        nitrogen
        obsidian
        pavucontrol
        picom
        nordic
        rofi
        telegram-desktop
        floorp
        vivaldi
        volumeicon
        xarchiver
        xclip
        xorg.xhost
        zeal-qt6
      ] ++ lib.optionals (pkgs.system == "x86_64-linux") [
        pkgs.vivaldi-ffmpeg-codecs
        pkgs.discord
      ];

    profiles.myfonts.enable = true;
    programs = {
      gnupg.agent = { pinentryPackage = lib.mkForce pkgs.pinentry-curses; };
      chromium.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages = with pkgs;
          [ tridactyl-native ]
          ++ lib.optionals (pkgs.system == "x86_64-linux") [ fx-cast-bridge ];
      };
    };

    qt.platformTheme = "gtk2";

    services = {
      dbus.packages = [ pkgs.dconf ];

      openssh.settings.X11Forwarding = true;

      desktopManager.plasma6.enable = true;
      xserver = {
        enable = true;
        libinput.enable = true;
        windowManager = { i3 = { enable = true; }; };
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
      };
      displayManager = {
        sddm = {
          # greeters.gtk.enable = true;
          # greeters.gtk.theme.name = "Nordic";
          enable = true;
          wayland.enable = false;
        };

      };
      xrdp = {
        enable = true;
        defaultWindowManager = "startplasma-x11";

      };
      xscreensaver.enable = true;

    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
    # xdg.mime.defaultApplications = {
    #   "text/html" = "vivaldi-stable.desktop";
    #   "x-scheme-handler/http" = "vivaldi-stable.desktop";
    #   "x-scheme-handler/https" = "vivaldi-stable.desktop";
    #   "x-scheme-handler/about" = "vivaldi-stable.desktop";
    #   "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    # };
    # environment.sessionVariables.DEFAULT_BROWSER =
    #   "${pkgs.vivaldi}/bin/vivaldi";
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
  };
}
