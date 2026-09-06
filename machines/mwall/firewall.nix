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
        "admin"
      ];

    };
    nat = {
      enable = true;
      internalInterfaces = [
        "lan"
        "iot"
      ];
      externalInterface = "wan";
      forwardPorts = [
        {
          sourcePort = 443;
          proto = "tcp";
          destination = "192.168.86.20:18443";
        }
        {
          sourcePort = 32400;
          proto = "tcp";
          destination = "192.168.86.20:32400";
        }
      ];
    };
  };
}
