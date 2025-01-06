{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

  ];

  age.secrets.cloudflareToken.owner = "caddy";
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "mcloud";
  networking.domain = "means.no";
  services.k3s = {
    enable = false;
  };
  services = {
    gotosocial = {
      enable = true;
      settings = {
        application-name = "means.no";
        host = "means.no";
        accounts-registration-open = true;
      };
    };
    openssh.enable = true;
    caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
        hash = "sha256-WGV/Ve7hbVry5ugSmTYWDihoC9i+D3Ct15UKgdpYc9U=";
      };
      configFile = ../../config/Caddyfile.mcloud;
      adapter = "caddyfile";
    };
  };
  systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz"
  ];
}
