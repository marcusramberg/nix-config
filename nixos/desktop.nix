{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dms = inputs.dank-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dmsPlugins = pkgs.fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dms-plugins";
    rev = "68299c5d7e04fd9ca219cb40eb6365beebaefd1c";
    hash = "sha256-igRtQXvBaDx7hJu0lepA+S7QSovehkY4fi4C1RUSrVo=";
  };
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  schemaDir = pkgs.glib.makeSchemaPath gsettingsSchemas gsettingsSchemas.name;
  worldClock = pkgs.fetchFromGitHub {
    owner = "rochacbruno";
    repo = "WorldClock";
    rev = "3e9b62ae2fe7550891a61436ebe8248a9724bd93";
    hash = "sha256-SYGB+04NNGiuRVaQ7wEFcM+Cbo0raVDgaZ0fnxAbVpc=";
  };
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "niri+dank environment";
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
      sessionVariables = {
        GSETTINGS_SCHEMA_DIR = schemaDir;
        NIXOS_OZONE_WL = "1";
        QML2_IMPORT_PATH = lib.concatStringsSep ":" [
          "${quickshell}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
          "${pkgs.kdePackages.sonnet}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtimageformats}/lib/qt-6/qml"
        ];
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";

      };
      systemPackages =
        with pkgs;
        [
          adw-gtk3
          bazaar
          bitwarden-desktop
          element-desktop
          ghostty
          hunspell
          hunspellDicts.en_US
          nautilus
          neovide
          showmethekey
          vlc
          wl-clipboard
          wl-clip-persist
          waypipe
          (vivaldi.override {
            enableWidevine = true;
            proprietaryCodecs = true;
          })
          vivaldi-ffmpeg-codecs
          spotify-player
          telegram-desktop
          signal-desktop
          vesktop
          wtype
        ]
        ++ (with kdePackages; [
          breeze-icons
          dolphin
          dolphin-plugins
          kaccounts-providers
          kio-gdrive
          qt6ct
          qtdeclarative
          tokodon
        ]);
    };

    profiles.myfonts.enable = true;
    programs = {
      chromium.enable = true;
      dms-shell = {
        enable = true;
        package = dms;
        quickshell.package = quickshell;
        plugins = {
          dankActions = {
            enable = true;
            src = "${dmsPlugins}/DankActions";
          };
          dankBatteryAlerts = {
            enable = true;
            src = "${dmsPlugins}/DankBatteryAlerts";
          };
          dankGifSearch = {
            enable = true;
            src = "${dmsPlugins}/DankGifSearch";
          };
          dankStickerSearch = {
            enable = true;
            src = "${dmsPlugins}/DankStickerSearch";
          };
          dankLauncherKeys = {
            enable = true;
            src = "${dmsPlugins}/DankLauncherKeys";
          };
          dankKDEConnect = {
            enable = true;
            src = "${dmsPlugins}/DankKDEConnect";
          };
          dankPomodoroTimer = {
            enable = true;
            src = "${dmsPlugins}/DankPomodoroTimer";
          };
          worldClock = {
            enable = true;
            src = worldClock;
          };

        };
      };
      dsearch.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages =
          with pkgs;
          [ tridactyl-native ]
          ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [ fx-cast-bridge ];
      };
      foot = {
        enable = true;
        enableFishIntegration = true;
      };
      kdeconnect.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };
      niri.enable = true;
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };

    qt = {
      enable = true;
      style = "breeze";
    };

    services = {
      displayManager = {
        dms-greeter = {
          enable = true;
          package = dms;
          quickshell.package = quickshell;
          compositor.name = "niri";
          configHome = "/home/marcus";
        };
        defaultSession = lib.mkForce "niri";
      };
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      orca.enable = false;
      power-profiles-daemon.enable = true;
      upower.enable = true;

      xserver = {
        enable = false;
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
      };
    };
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
    security.pam.services = {
      greetd.fprintAuth = lib.mkDefault false;
    };
    xdg = {
      portal.xdgOpenUsePortal = true;
      mime = {
        enable = true;
        defaultApplications."inode/directory" = "dolphin.desktop";
      };
    };
  };
}
