{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.dmsMobile;
  dms = inputs.dmsmobile.packages.${pkgs.stdenv.hostPlatform.system}.default;
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  schemaDir = pkgs.glib.makeSchemaPath gsettingsSchemas gsettingsSchemas.name;
in

{
  options = {
    profiles.dmsMobile = {
      enable = lib.mkEnableOption "Enable DMS Mobile configuration";
      debug.enable = lib.mkEnableOption "Enable additional debugging features, such as a serial console in the initrd";
      display = lib.mkOption {
        type = lib.types.str;
        default = "DSI-1";
        description = "Display output";
      };
    };
  };
  config = lib.mkIf cfg.enable {
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
      systemPackages = with pkgs; [
        bazaar
        firefox-mobile
        wl-clipboard
        telegram-desktop
      ];
    };
    programs = {
      dms-shell = {
        enable = true;
        package = dms;
      };
      dsearch.enable = true;
      foot = {
        enable = true;
        enableFishIntegration = true;
      };
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };
      niri = {
        enable = true;
      };
    };
    services = {
      displayManager = {
        dms-greeter = {
          enable = true;
          package = dms;
          compositor.name = "niri";
          configHome = "/home/marcus";
        };
        defaultSession = lib.mkDefault "niri";
      };
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      orca.enable = false;
      power-profiles-daemon.enable = true;
      upower.enable = true;

      logind.settings.Login = {
        HandlePowerKey = "ignore";
      };
    };
    systemd = {
      user.services.dms.environment.DMS_MOBILE = "1";
      user.services = {
        dms.wantedBy = lib.mkForce [
          "niri.service"
          "springchick.service"
        ];
        rotation = {
          description = "Screen rotation for DMS Mobile";
          after = [ "niri.service" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "niri.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.writeShellScript "update-rotation" ''
              ${pkgs.toybox}/bin/killall monitor-sensor
              ${pkgs.iio-sensor-proxy}/bin/monitor-sensor > /dev/shm/sensor.log 2>&1 &
              while ${pkgs.inotify-tools}/bin/inotifywait -e modify /dev/shm/sensor.log; do
                sleep 0.5
                ORIENTATION=$(${pkgs.coreutils}/bin/tail /dev/shm/sensor.log | ${pkgs.gnugrep}/bin/grep 'orientation' | tail -1 | grep -oE '[^ ]+$')
                case "$ORIENTATION" in
                  normal)
                    ${pkgs.niri}/bin/niri msg output ${cfg.display} transform normal
                    ;;
                  left-up)
                    ${pkgs.niri}/bin/niri msg output ${cfg.display} transform 90
                    ;;
                  bottom-up)
                    ${pkgs.niri}/bin/niri msg output ${cfg.display} transform 180
                    ;;
                  right-up)
                    ${pkgs.niri}/bin/niri msg output ${cfg.display} transform 270
                    ;;
                esac
              done
            ''}";
            Restart = "always";
            RestartSec = 5;
          };
        };
        wvkbd = {
          description = "On-screen keyboard";
          partOf = [ "graphical-session.target" ];
          wantedBy = [
            "niri.service"
            "springchick.service"
          ];
          serviceConfig = {
            ExecStart = "${pkgs.wvkbd}/bin/wvkbd-mobintl --alpha 220 --hidden --auto";
            Restart = "always";
            RestartSec = 5;
          };
        };
      };
      services.flatpak-remote-add-flathub = {
        description = "Add Flathub repository for Flatpak";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
          # Restart on failure (e.g., network not actually connected yet).
          Restart = "on-failure";
          RestartSec = "30s";
          # Give up after 20 attempts to avoid infinite retries.
          StartLimitBurst = 20;
        };
      };
    };

    virtualisation = {
      waydroid.enable = true;
    };
  };
}
