{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf cfg.enable {

    # Enable plymouth
    boot = {
      initrd.systemd.enable = true; # This is needed to show the plymouth login screen to unlock luks
      plymouth = {
        enable = true;
        theme = "breeze";
      };
    };

    environment.systemPackages =
      with pkgs;
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
      ]
      ++ lib.optionals (system == "x86_64-linux") [
        vivaldi-ffmpeg-codecs
        discord
      ];

    profiles.myfonts.enable = true;
    programs = {
      gnupg.agent = {
        pinentryPackage = lib.mkForce pkgs.pinentry-curses;
      };
      chromium.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages =
          with pkgs;
          [ tridactyl-native ] ++ lib.optionals (pkgs.system == "x86_64-linux") [ fx-cast-bridge ];
      };
    };

    qt.platformTheme = "gtk2";

    services = {
      dbus.packages = [ pkgs.dconf ];

      openssh.settings.X11Forwarding = true;

      libinput.enable = true;
      xserver = {
        enable = true;
        displayManager.lightdm = {
          enable = true;
          greeters.slick.enable = true;
        };
        windowManager = {
          i3 = {
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
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
      };
      xrdp = {
        enable = true;
        defaultWindowManager = "startplasma-x11";

      };
      xscreensaver.enable = true;

    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
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
