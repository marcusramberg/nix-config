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

    networking.firewall.allowedUDPPorts = [
      80
      443
    ];
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy-secrets.path;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.0.0-20250420134112-006ebb07b349"
          "github.com/greenpau/caddy-security@v1.1.31"
        ];
        hash = "sha256-dKeQhWG4I2r4+YZsEIAU2Ef6KhdWf2422G9Z7FAjD6U=";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
