{
  systemd.network = {
    enable = true;

    links = {
      # gmac1: the combo port marked WAN. The eth-mux picks sfp2 or the phy24
      # RJ45 from mod-def0, so this one netdev covers both.
      # No Name=: mtk_soc_eth renames eth1 -> end1 from the DT label after the
      # netdev is registered, i.e. after udev has run net_setup_link, so the
      # kernel name wins and name_assign_type ends up NET_NAME_RENAMED. The
      # MAC still applies. Everything downstream matches end1.
      "10-wan" = {
        matchConfig.OriginalName = "end1";
        linkConfig = {
          Description = "WAN Interface";
          MACAddress = "02:bb:c6:06:62:01";
        };
      };
    };

    netdevs = {
      "switch" = {
        netdevConfig = {
          Name = "switch";
          Kind = "bridge";
          # DSA ports inherit the conduit's MAC, which is random every boot, so
          # an unpinned bridge picks a new address from its lowest member and
          # every gateway IP moves with it. The vlans on top inherit this.
          MACAddress = "02:bb:c6:06:62:05";
        };
        # must be set here, at creation: mxl862xx locks vlan_filtering once a
        # port has joined and returns -ENOTSUPP for any later change
        extraConfig = ''
          [Bridge]
          DefaultPVID=1
          VLANFiltering=yes
        '';
      };
      "lan" = {
        netdevConfig = {
          Name = "lan";
          Kind = "vlan";
        };
        vlanConfig.Id = 1;
      };
      "isolated" = {
        netdevConfig = {
          Name = "isolated";
          Kind = "vlan";
        };
        vlanConfig.Id = 66;
      };
      "iot" = {
        netdevConfig = {
          Name = "iot";
          Kind = "vlan";
        };
        vlanConfig.Id = 99;
      };
      # named admin, not mgmt: the board already has a DSA port called mgmt
      "admin" = {
        netdevConfig = {
          Name = "admin";
          Kind = "vlan";
        };
        vlanConfig.Id = 255;
      };
    };

    networks = {
      "99-ethernet-default-dhcp".enable = false;
      "99-wireless-client-dhcp".enable = false;
      "wan" = {
        matchConfig.Name = "end1";
        networkConfig.DHCP = "ipv4";
        dhcpConfig.RouteMetric = "10";
        # address = [ "172.30.0.2/24" ];
        # routes = [
        #   {
        #     Gateway = "172.30.0.1";
        #     Metric = 10;
        #   }
        # ];
      };

      # The 1G jack, kept as a rescue port: plug a laptop in at 10.10.10.2 and
      # ssh to .1 no matter what the rest of the routing is doing. Static and
      # gateway-less on purpose - a DHCP lease here would land in the house
      # switch's 192.168.86.0/24, the same prefix as our own lan, and one of the
      # two would swallow the route. This subnet collides with nothing, so the
      # port is equally safe direct-attached or left in the switch.
      # lan5 is the 7.2 name for mgmt; only one of the two ever exists
      "10-mgmt" = {
        matchConfig.Name = "mgmt lan5";
        networkConfig.ConfigureWithoutCarrier = "yes";
        address = [ "10.10.10.1/24" ];
      };

      # DSA conduits: end0 carries the mt7530 (mgmt), end2 the mxl862xx
      # (lan0-lan4). They must be up but are never addressed or bridged.
      "conduits" = {
        matchConfig.Name = "end0 end2";
        networkConfig.LinkLocalAddressing = "no";
        linkConfig = {
          RequiredForOnline = "no";
          ActivationPolicy = "always-up";
        };
      };

      # mxl862xx ports only. mgmt/lan5 is on the mt7530, a separate dsa tree
      # (dsa,member <1 0> vs <0 0>), and dsa cannot offload a bridge across
      # trees - enslaving it here would software-forward every frame via the cpu.
      #
      # Covers both DT generations: 6.18 numbers these lan0-lan4, 7.2 shifts
      # them to lan1-lan4 plus lan6 for the combo port. lan5 is absent from
      # both lists on purpose - under 7.2 that is the 1G jack.
      "switchdevs" = {
        matchConfig.Name = "lan0 lan1 lan2 lan3 lan4 lan6";
        networkConfig.Bridge = "switch";
        extraConfig = ''
          [BridgeVLAN]
          PVID=1
          VLAN=1
          EgressUntagged=1
          [BridgeVLAN]
          VLAN=66
          [BridgeVLAN]
          VLAN=99
          [BridgeVLAN]
          VLAN=255
        '';
      };

      "switch" = {
        matchConfig.Name = "switch";
        networkConfig = {
          VLAN = [
            "lan"
            "isolated"
            "iot"
            "admin"
          ];
          LinkLocalAddressing = "no";
        };
        linkConfig.RequiredForOnline = "no";
        bridgeVLANs = [
          { VLAN = "1"; }
          { VLAN = "66"; }
          { VLAN = "99"; }
          { VLAN = "255"; }
        ];
      };

      "lan" = {
        matchConfig.Name = "lan";
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "yes";
        };
        # Safe to hold the real gateway address on the bench: vlan1 rides only
        # the mxl862xx ports, and lan5 - the one jack on the house switch - is
        # on the mt7530, a different DSA tree, deliberately not in this bridge.
        # Nothing mwall serves can reach mgate's LAN.
        address = [ "192.168.86.1/24" ];
      };
      "isolated" = {
        matchConfig.Name = "isolated";
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.69.1/24" ];
      };
      "iot" = {
        matchConfig.Name = "iot";
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.68.1/24" ];
      };
      "admin" = {
        matchConfig.Name = "admin";
        networkConfig = {
          ConfigureWithoutCarrier = "yes";
          MulticastDNS = "no";
        };
        address = [ "192.168.50.1/24" ];
      };
    };
  };
}
