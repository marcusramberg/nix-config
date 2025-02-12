{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.caddy;
  hashes = {
    x86_64-linux = "sha256-JVkUkDKdat4aALJHQCq1zorJivVCdyBT+7UhqTvaFLw=";
    aarch64-linux = "sha256-JVkUkDKdat4aALJHQCq1zorJivVCdyBT+7UhqTvaFLw=";
  };
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
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = hashes."${pkgs.system}";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
