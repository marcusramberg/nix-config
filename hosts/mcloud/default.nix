_: {
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
  profiles.caddy = {
    enable = true;
    configFile = ../../config/Caddyfile.mcloud;
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
  };
  systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz"
  ];
}
