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
        (catppuccin-gtk.override {
          variant = "mocha";
          accents = [
            "blue"
            "teal"
            "lavender"
          ];

        })
        (catppuccin-kde.override {
          flavour = [ "mocha" ];
          accents = [
            "blue"
            "teal"
            "lavender"
          ];

        })
        catppuccin-qt5ct
        catppuccin-cursors
        catppuccin-kvantum
        (catppuccin-sddm.override {
          flavor = "mocha";
          font = "Noto Sans";
          fontSize = "9";
          # background = "${./wallpaper.png}";
          # loginBackground = true;
        })
        copyq
        element-desktop
        feh
        flameshot
        floorp
        ghostty
        gnomeExtensions.appindicator
        gnomeExtensions.just-perfection
        gnomeExtensions.paperwm
        nitrogen
        obsidian
        pantheon.sideload
        pavucontrol
        picom
        rofi
        signal-desktop
        tauon
        telegram-desktop
        vivaldi
        volumeicon
        webcord-vencord
        xarchiver
        xclip
        xorg.xhost
        waypipe
        ytmdesktop
        zafiro-icons
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
      displayManager.defaultSession = lib.mkForce "plasma";

      flatpak.enable = true;

      openssh.settings.X11Forwarding = true;

      gnome.core-utilities.enable = false;
      libinput.enable = true;
      displayManager.sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        settings.General.InputMethod = "";
      };
      desktopManager.plasma6.enable = true;
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
        enable = false;
        defaultWindowManager = "startplasma-x11";

      };

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
    xdg.portal.enable = true;
  };
}
