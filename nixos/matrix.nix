{ lib, ... }:
with lib;
let
  cfg = config.profile.matrix-server;
in
{
  options.profile.matrix-server.enable = mkEnableOption "Matrix server";
  config.services.matrix-conduit = mkIf cfg.enable {
    enable = true;
    settings.global = {
      server_name = "means.no";
      address = "0.0.0.0";
    };
  };
}
