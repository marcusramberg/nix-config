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

      # Rescue port. ssh only, not trusted
      interfaces."lan5".allowedTCPPorts = [ 22 ];
    };
    nat = {
      enable = true;
      internalInterfaces = [
        "lan"
        "iot"
      ];
      externalInterface = "end1";
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
