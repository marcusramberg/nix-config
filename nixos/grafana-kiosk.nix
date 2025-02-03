{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.grafana-kiosk;
in
{
  options = {
    services.grafana-kiosk = {

      enable = mkEnableOption "grafana-kiosk, a way to show grafana dashboards in kiosk mode.";

      package = mkPackageOption pkgs "grafana-kiosk" { };

      user = mkOption {
        type = types.str;
        default = "grafana-kiosk";
        description = "User account under which grafana-kiosk runs.";
      };

      group = mkOption {
        type = types.str;
        default = "grafana-kiosk";
        description = "Group under which grafana-kiosk runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.user.services.grafana-kiosk = {
      documentation = [
        "https://github.com/grafana/grafana-kiosk"
        "https://grafana.com/blog/2019/05/02/grafana-tutorial-how-to-create-kiosks-to-display-dashboards-on-a-tv"
      ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/grafana-kiosk -nobrowser -data='${cfg.dataDir}'";
        # ExecStart=/usr/bin/grafana-kiosk -URL=<url> -login-method=local -username=<username> -password=<password> -playlists=true
        Restart = "on-failure";
        Environment = {
          DISPLAY = ":0";
          XAUTHORITY = "/home/pi/.Xauthority";
        };
        ExecStartPre = [
          "xset s off"
          "xset -dpms"
          "xset s noblank"
        ];
        PassEnvironment = "DISPLAY";
        RestartSec = 3;
        description = "Grafana Kiosk";
        After = [ "network.target" ];
        WantedBy = [ "graphical.target" ];
      };
    };

    users.users = mkIf (cfg.user == "grafana-kiosk") {
      grafana-kiosk = {
        description = "grafana-kiosk service";
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "grafana-kiosk") { grafana-kiosk = { }; };
  };
}
