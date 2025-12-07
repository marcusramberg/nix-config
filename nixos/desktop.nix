{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  dms = inputs.dank-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop environment with plasma and catppuccin theme";
    niri.enable = lib.mkEnableOption "enable niri environment";
  };

  config = lib.mkIf cfg.enable {

    # Enable plymouth
    boot = {
      initrd.systemd.enable = true; # This is needed to show the plymouth login screen to unlock luks
      plymouth = {
        enable = true;
        theme = "catppuccin-mocha";
        themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      };
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
    };

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        kwin-x11
        kate
        ktexteditor
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        (catppuccin.override {
          variant = "mocha";
          accent = "lavender";
          themeList = [
            "bat"
            "btop"
            "element"
            "k9s"
            "lazygit"
            "waybar"
          ];
        })
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
          winDecStyles = [
            "classic"
          ];
          accents = [
            "blue"
            "teal"
            "lavender"
          ];

        })
        catppuccin-cursors.mochaLavender
        (catppuccin-kvantum.override {
          variant = "mocha";
          accent = "lavender";
        })
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        })
        (catppuccin-sddm.override {
          flavor = "mocha";
          font = "JetBrainsMono Nerd Font Propo";
          fontSize = "9";
        })
        ghostty
        hunspell
        hunspellDicts.en_US
        kdePackages.kaccounts-providers
        kdePackages.karousel
        kdePackages.kio-gdrive
        kdePackages.qtdeclarative
        webcord-vencord
      ];
    };

    profiles.myfonts.enable = true;
    programs = {
      chromium.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages =
          with pkgs;
          [ tridactyl-native ]
          ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [ fx-cast-bridge ];
      };
      kdeconnect.enable = true;
      niri.enable = cfg.niri.enable;
      dms-shell = {
        enable = true;
        package = dms;
        quickshell.package = quickshell;
      };
      dsearch.enable = true;

      ssh.enableAskPassword = true;
    };

    qt = {
      enable = true;
      style = "breeze";
      platformTheme = "kde";
    };

    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      dbus.packages = [ pkgs.dconf ];
      displayManager = {
        dms-greeter = {
          inherit (cfg.niri) enable;
          package = dms;
          quickshell.package = quickshell;
          logs.save = true;
          compositor.name = "niri";
          configHome = "/home/marcus";
        };
        sddm = {
          enable = !cfg.niri.enable;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
          theme = "catppuccin-mocha-mauve";
          settings.General.InputMethod = "";
        };
        defaultSession = lib.mkForce (if cfg.niri.enable then "niri" else "plasma");
      };
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      orca.enable = false;
      xserver = {
        enable = false;
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
      };
    };
    environment.sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${quickshell}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      "${pkgs.kdePackages.sonnet}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
    ];
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
    xdg.portal.xdgOpenUsePortal = true;
  };
}
