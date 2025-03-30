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
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = "sha256-W09nFfBKd+9QEuzV3RYLeNy2CTry1Tz3Vg1U2JPNPPc=";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
