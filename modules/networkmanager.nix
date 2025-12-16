{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.networking.networkmanager;
in
{
  # Auto-configure NetworkManager-wait-online service when NetworkManager is enabled
  config = mkIf cfg.enable {
    systemd.services.NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.networkmanager}/bin/nm-online -q"
        ];
      };
    };
  };
}