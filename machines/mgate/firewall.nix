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

    };
    nftables = {
      enable = true;
      ruleset = ''
        add rule inet nixos-fw forward-allow iifname { "lan", "iot" } oifname "he-ipv6" accept comment "allow IPv6 through tunnel"
      '';
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
