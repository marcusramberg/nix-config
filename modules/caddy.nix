{
  lib,
  config,
  inputs,
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

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy-secrets.path;
      package = inputs.caddy-stack.packages.${pkgs.system}.default;
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
