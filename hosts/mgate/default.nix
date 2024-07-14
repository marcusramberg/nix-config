{ lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Install static leases from agenix
  age.secrets.leases = {
    path = "/etc/systemd/network/lan.network.d/lan.network.conf";
    mode = "644";
  };
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "pcie_aspm=off" ];
    kernel.sysctl = {
      "net.core.rmem_max" = 4194304;
      "net.ipv4.igmp_max_memberships" = 1024;
      "net.ipv4.igmp_max_msf" = 10;
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };

  networking = {
    hostName = "mgate";
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkForce true;
      allowedTCPPorts = [ 443 ];
      trustedInterfaces = [
        "tailscale0"
        "lan"
        "iot"
        "mgmt"
      ];

    };
    nftables = {
      enable = true;
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
      ];
    };
  };
  services = {
    openssh.openFirewall = false;
    avahi = {
      enable = true;
      nssmdns4 = true;
      allowInterfaces = [
        "lan"
        "iot"
      ];
    };
    prometheus.exporters.node = {
      enable = true;
      openFirewall = false;
    };
  };
  system.stateVersion = "23.05";
  systemd.network = {
    enable = true;
    wait-online = {
      anyInterface = true;
      ignoredInterfaces = [ "tailscale0" ];
    };

    links = {
      "10-wan" = {
        enable = true;
        matchConfig.Path = "pci-0000:04:00.0";
        linkConfig = {
          Name = "wan";
          Description = "WAN Interface";
        };
      };
      "11-unused-1" = {
        enable = true;
        matchConfig.Path = "pci-0000:09:00.0";
        linkConfig = {
          Name = "unused-1";
        };
      };
      "12-unused-2" = {
        enable = true;
        matchConfig.Path = "pci-0000:0a:00.0";
        linkConfig = {
          Name = "unused-2";
        };
      };
      "20-wlan" = {
        enable = true;
        matchConfig.Path = "pci-0000:00:14.0-usb-0:10:1.0";
        linkConfig = {
          Name = "wlan";
          Description = "WLAN interface";
        };
      };
    };
    networks = {
      "wan" = {
        name = "wan";
        enable = true;
        matchConfig = {
          Name = "wan";
        };
        networkConfig = {
          DHCP = "ipv4";
        };
        dhcpConfig = {
          RouteMetric = "10";
        };
      };
      "switch" = {
        enable = true;
        matchConfig = {
          Name = "switch";
        };
        networkConfig = {
          VLAN = [
            "lan"
            "isolated"
            "iot"
            "mgmt"
          ];
          LinkLocalAddressing = "no";
        };
        linkConfig.RequiredForOnline = "no";
        bridgeVLANs = [
          {
            bridgeVLANConfig = {
              VLAN = "1";
            };
          }
          {
            bridgeVLANConfig = {
              VLAN = "66";
            };
          }
          {
            bridgeVLANConfig = {
              VLAN = "99";
            };
          }
          {
            bridgeVLANConfig = {
              VLAN = "255";
            };
          }
        ];
      };
      "switchdevs" = {
        enable = true;
        matchConfig = {
          Name = "en*";
        };
        networkConfig = {
          Bridge = "switch";
        };
        extraConfig = ''
          [Bridge]
          PVID=1
          VLAN=1
          EgressUntagged = 1
          [Bridge]
          VLAN = 66
          [Bridge]
          VLAN = 99
          [Bridge]
          VLAN = 255
        '';
      };
      "lan" = {
        name = "lan";
        enable = true;
        matchConfig = {
          Name = "lan";
        };
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "yes";
          DHCPServer = true;
        };
        dhcpServerConfig = {
          PoolOffset = 20;
          PoolSize = 200;
        };
        address = [ "192.168.86.1/24" ];
      };
      "isolated" = {
        name = "isolated";
        enable = true;
        matchConfig = {
          Name = "isolated";
        };
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.69.1/24" ];
      };
      "iot" = {
        name = "iot";
        enable = true;
        matchConfig = {
          Name = "iot";
        };
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.68.1/24" ];
      };
      "mgmt" = {
        name = "mgmt";
        enable = true;
        matchConfig = {
          Name = "mgmt";
        };
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.50.1/24" ];
      };
    };
    netdevs = {
      "lan" = {
        enable = true;
        netdevConfig = {
          Name = "lan";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 1;
        };
      };
      "isolated" = {
        enable = true;
        netdevConfig = {
          Name = "isolated";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 66;
        };
      };
      "iot" = {
        enable = true;
        netdevConfig = {
          Name = "iot";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 99;
        };
      };
      "mgmt" = {
        enable = true;
        netdevConfig = {
          Name = "mgmt";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 255;
        };
      };
      "switch" = {
        enable = true;
        netdevConfig = {
          Name = "switch";
          Kind = "bridge";
        };
        extraConfig = ''
          [Bridge]
          DefaultPVID=1
          VLANFiltering=yes
        '';
      };
    };
  };
}
