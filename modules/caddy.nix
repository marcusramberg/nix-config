{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.profiles.caddy;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
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
    environment.systemPackages = [
      inputs.caddy-stack.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.caddy = {
      enable = true;
      environmentFile = config.age.secrets.caddy-secrets.path;
      package = inputs.caddy-stack.packages.${pkgs.stdenv.hostPlatform.system}.default;
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
    systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  };
}
