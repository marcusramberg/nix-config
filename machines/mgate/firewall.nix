{ lib, ... }:
{
  networking = {
    firewall = {
      enable = lib.mkForce true;
      logRefusedConnections = false;
      filterForward = true;

      trustedInterfaces = [
        "tailscale0"
        "lan"
        "iot"
        "mgmt"
      ];

      backend = "firewalld";
    };
  };
}
