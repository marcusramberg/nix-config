{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  # quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dms = inputs.dank-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dmsRegistry = inputs.dms-plugin-registry.packages.${pkgs.system};
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  schemaDir = pkgs.glib.makeSchemaPath gsettingsSchemas gsettingsSchemas.name;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "niri+dank environment";
    displayManager = lib.mkEnableOption "display manager (dms-greeter)" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    hardware.i2c.enable = true;

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
      };
      systemPackages =
        with pkgs;
        [
          adw-gtk3
          bazaar
          bitwarden-desktop
          distrobox
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
          spotify-player
          telegram-desktop
          signal-desktop
          vesktop
          wtype
        ]
        ++ (with kdePackages; [
          breeze-icons
          kaccounts-providers
          qt6ct
          qtdeclarative
          tokodon
        ]);
    };

    profiles.myfonts.enable = true;
    programs = {
      dms-shell = {
        enable = true;
        package = dms;
        # quickshell.package = quickshell;
        plugins = {
          dankActions = {
            enable = true;
            src = dmsRegistry.dankActions;
          };
          dankBatteryAlerts = {
            enable = true;
            src = dmsRegistry.dankBatteryAlerts;
          };
          dankGifSearch = {
            enable = true;
            src = dmsRegistry.dankGifSearch;
          };
          dankStickerSearch = {
            enable = true;
            src = dmsRegistry.dankStickerSearch;
          };
          dankLauncherKeys = {
            enable = true;
            src = dmsRegistry.dankLauncherKeys;
          };
          dankKDEConnect = {
            enable = true;
            src = dmsRegistry.dankKDEConnect;
          };
          dankPomodoroTimer = {
            enable = true;
            src = dmsRegistry.dankPomodoroTimer;
          };
          worldClock = {
            enable = true;
            src = dmsRegistry.worldClock;
          };
          quickCapture = {
            enable = true;
            src = dmsRegistry.quickCapture;
          };
        };
      };
      dsearch.enable = true;
      evolution.enable = false;
      gnome-terminal.enable = false;
      foot = {
        enable = true;
        enableFishIntegration = true;
      };
      kdeconnect.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };
      niri = {
        enable = true;
      };
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };

    qt = {
      enable = true;
      style = "breeze";
    };

    services = {
      keybase.enable = true;
      displayManager = lib.mkIf cfg.displayManager {
        dms-greeter = {
          enable = true;
          package = pkgs.dms-shell;
          # quickshell.package = quickshell;
          compositor.name = "niri";
          configHome = "/home/marcus";
        };
        defaultSession = lib.mkDefault "niri";
      };
      desktopManager.gnome.enable = true;
      gnome.evolution-data-server.enable = lib.mkForce false;
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
    security = {
      pam.services = {
        greetd.fprintAuth = lib.mkDefault false;
      };
      polkit = {
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
      tpm2.enable = true;
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
