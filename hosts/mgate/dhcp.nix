{
  services = {
    kea = {
      dhcp4 = {
        enable = true;
        settings = {
          valid-lifetime = 3600;
          renew-timer = 900;
          rebind-timer = 1800;

          lease-database = {
            type = "memfile";
            persist = true;
            name = "/var/lib/kea/dhcp4.leases";
          };

          control-socket = {
            socket-type = "unix";
            socket-name = "/run/kea/dhcp4.sock";
          };

          interfaces-config = {
            dhcp-socket-type = "raw";
            interfaces = [ "lan" ];

            # stupid hack to make Kea wait ~forever (really one day) for the bridge to be up
            service-sockets-max-retries = 86400000;
            service-sockets-retry-wait-time = 1000;
          };

          option-data = [
            {
              name = "routers";
              data = "192.168.86.1";
            }
            {
              name = "domain-name-servers";
              data = "192.168.86.1";
            }
            {
              name = "domain-name";
              data = "lan";
            }
            {
              name = "domain-search";
              data = "lan";
            }
          ];

          subnet4 = [
            {
              id = 1;
              subnet = "192.168.86.0/24";
              pools = [ { pool = "192.168.86.2 - 192.168.86.254"; } ];
              reservations = import ./dhcp-hosts.nix;
            }
          ];
        };
      };

      ctrl-agent = {
        enable = true;
        settings = {
          http-host = "127.0.0.1";
          http-port = 4000;
          control-sockets.dhcp4 = {
            socket-type = "unix";
            socket-name = "/run/kea/dhcp4.sock";
          };
        };
      };
    };

    prometheus.exporters.kea = {
      enable = true;
      controlSocketPaths = [
        "http://127.0.0.1:4000"
      ];
    };

  };

  networking.firewall.interfaces.lan.allowedUDPPorts = [ 67 ];
}
