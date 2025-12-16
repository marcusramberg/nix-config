{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.caddy;
in
{

  options.profiles.caddy = {
    enable = mkEnableOption "Caddy webserver";
    configFile = mkOption {
      type = types.path;
      description = "caddy config file";
    };

  };

  config = mkIf cfg.enable {
    # Setup Cloudflare token secret for caddy
    age.secrets.cloudflareToken.owner = "caddy";

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = "sha256-kbTKCPjjIGRZZ550lBg0c5Ye4AK4o5yCRynBIvCLYkQ=";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };

    # Allow caddy to bind to privileged ports
    systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  };
}
