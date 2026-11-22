# stoandl, the headless Pebble smartwatch companion daemon.
#
# It is a *user* service, not a system one: it forwards the desktop's
# notifications, so it listens on the session bus
# (`org.freedesktop.Notifications`) and owns `de.yoxcu.stoandl.Control` there
# for the GUI and the `stoandl` CLI to call. Its state and configuration live
# in `$XDG_CONFIG_HOME/stoandl` (`~/.config/stoandl`) -- mutable, because the
# CLI and the GUI both write `stoandl.conf`, so this module deliberately does
# not generate it. Copy the shipped example to start from:
#
#   cp ${pkgs.stoandl}/share/doc/stoandl/stoandl.conf.example \
#     ~/.config/stoandl/stoandl.conf
#
# The watch link is BlueZ: BLE for Pebble 2 / Time 2, Bluetooth Classic (RFCOMM)
# for the classic-era watches, hence the hardware.bluetooth dependency.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.stoandl;
in
{
  options.programs.stoandl = {
    enable = lib.mkEnableOption ''
      stoandl, the headless Pebble smartwatch companion daemon, as a systemd
      user service bridging desktop notifications, music, weather, calendar
      and health to the watch over BLE or Bluetooth Classic
    '';

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.stoandl;
      defaultText = lib.literalExpression "pkgs.stoandl";
      description = "The stoandl package to use.";
    };

    gui = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Install the Kirigami front-end (`stoandl-gui`) alongside
          the daemon. It is adaptive, so the same app is the phone and the
          desktop UI, and it is only a D-Bus client -- the daemon works
          headless without it.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.stoandl-gui;
        defaultText = lib.literalExpression "pkgs.stoandl-gui";
        description = "The stoandl GUI package to use.";
      };
    };

    logLevel = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "TRACE"
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
        ]
      );
      default = null;
      example = "DEBUG";
      description = ''
        Value for `STOANDL_LOG` in the service's environment. `null` leaves the
        daemon's own default in place.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hardware.bluetooth.enable;
        message = ''
          programs.stoandl: the daemon reaches the watch through
          BlueZ (BLE, or RFCOMM for classic-era watches), so
          hardware.bluetooth.enable must be on.
        '';
      }
    ];

    environment.systemPackages = [
      # The `stoandl` CLI: pairing, sideloading, firmware, config.
      cfg.package
    ]
    ++ lib.optional cfg.gui.enable cfg.gui.package;

    systemd.user.services.stoandl = {
      description = "stoandl -- Pebble companion daemon";
      wantedBy = [ "default.target" ];

      # bluetooth.target is a system unit; a user unit can only order itself
      # against the session's own graph, so the daemon has to cope with BlueZ
      # arriving late anyway -- Restart=on-failure is what covers that.
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      environment = lib.mkIf (cfg.logLevel != null) {
        STOANDL_LOG = cfg.logLevel;
      };

      serviceConfig = {
        Type = "simple";
        # The daemon entry point; `stoandl` (no `d`) is the CLI wrapper for the
        # same JAR.
        ExecStart = lib.getExe' cfg.package "stoandld";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
