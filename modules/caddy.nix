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
    age.secrets.cloudflareToken.owner = "caddy";
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy-secrets.path;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.0.0-20250420134112-006ebb07b349"
          "github.com/greenpau/caddy-security@v1.1.31"
        ];
        hash = "sha256-otQHdP+bJzMGdNpw2OSoarUbY3vOzHKJf8pNBHdIbjE=";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
