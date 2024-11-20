{
  config,
  # inputs,
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
        #bitwarden
        copyq
        element-desktop
        feh
        flameshot
        # inputs.ghostty.packages.${pkgs.system}.default
        gnomeExtensions.appindicator
        gnomeExtensions.paperwm
        gnomeExtensions.just-perfection
        nitrogen
        obsidian
        pavucontrol
        picom
        nordic
        pantheon.sideload
        rofi
        telegram-desktop
        floorp
        tauon
        vivaldi
        volumeicon
        webcord-vencord
        xarchiver
        xclip
        xorg.xhost
        ytmdesktop
      ]
      ++ lib.optionals (system == "x86_64-linux") [
        vivaldi-ffmpeg-codecs
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

    qt.style = "kvantum";

    services = {
      dbus.packages = [ pkgs.dconf ];
      displayManager.defaultSession = lib.mkForce "xfce+i3";

      flatpak.enable = true;

      openssh.settings.X11Forwarding = true;

      gnome.core-utilities.enable = false;
      libinput.enable = true;
      displayManager.sddm.enable = true;
      xserver = {
        enable = true;
        # displayManager.gdm.enable = true;
        # displayManager.lightdm = {
        #   greeters.slick.enable = true;
        # };
        windowManager = {
          i3 = {
            enable = true;
          };
        };
        desktopManager = {
          gnome.enable = true;
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
