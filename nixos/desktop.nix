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
    rev = "8fa7c5286171c66a209dd74e9a47d6e72ccfdad6";
    hash = "sha256-0RXRgUXXoX+C0q+drsShjx2rCTdmqFzOCR/1rGB/W2E=";
  };
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
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages =
        with pkgs;
        [
          bitwarden-desktop
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
          kdePackages.tokodon
          signal-desktop
          webcord-vencord
          wtype
        ]
        ++ (with kdePackages; [
          kaccounts-providers
          kio-gdrive
          discover
          dolphin
          dolphin-plugins
          qtdeclarative
        ]);
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
      dms-shell = {
        enable = true;
        package = dms;
        quickshell.package = quickshell;
        plugins = {
          "dankActions" = {
            enable = true;
            src = "${dmsPlugins}/DankActions";
          };
          "dankPomodoroTimer" = {
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
      platformTheme = "kde";
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
    environment.sessionVariables = {
      XDG_DATA_DIRS = lib.mkForce (
        lib.concatStringsSep ":" [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
          "${config.services.displayManager.sessionData.desktops}/share"
        ]
      );

      QML2_IMPORT_PATH = lib.concatStringsSep ":" [
        "${quickshell}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
        "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
        "${pkgs.kdePackages.sonnet}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
      ];
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
