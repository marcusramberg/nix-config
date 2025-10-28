{
  config,
  lib,
  pkgs,
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
        theme = "catppuccin-mocha";
        themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      };
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
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
          font = "JetBrainsMono Nerd Font Propo";
          fontSize = "9";
        })
        copyq
        element-desktop
        flameshot
        fuzzel
        geeqie
        ghostty
        hunspell
        hunspellDicts.en_US
        kdePackages.ksshaskpass
        kdePackages.kaccounts-providers
        kdePackages.karousel
        kdePackages.kdegraphics-thumbnailers
        kdePackages.kio-gdrive
        kdePackages.krdp
        kdePackages.plasma-browser-integration
        nixos-icons
        neovide
        obsidian
        pavucontrol
        showmethekey
        signal-desktop
        spotify-player
        swaybg
        telegram-desktop
        vivaldi
        vivaldi-ffmpeg-codecs
        vlc
        wl-clip-persist
        webcord-vencord
        xdg-utils
        wl-clipboard
        waypipe
        ytmdesktop
        zafiro-icons
      ];
    };

    profiles.myfonts.enable = true;
    programs = {
      chromium.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages =
          with pkgs;
          [ tridactyl-native ] ++ lib.optionals (pkgs.system == "x86_64-linux") [ fx-cast-bridge ];
      };
      gnupg.agent = {
        pinentryPackage = lib.mkForce pkgs.pinentry-curses;
      };
      kdeconnect.enable = true;
    };

    qt.style = "breeze";

    services = {
      displayManager.sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        theme = "catppuccin-mocha-mauve";
        settings.General.InputMethod = "";
      };
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      dbus.packages = [ pkgs.dconf ];
      displayManager.defaultSession = lib.mkForce "plasma";
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      libinput.enable = true;
      openssh.settings.X11Forwarding = true;
      xserver = {
        enable = false;
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
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
    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
