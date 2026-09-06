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

          # kea 3.2 dropped the control agent; dhcp4 serves http itself, but it
          # refuses an http channel with neither auth nor TLS ("Unsecured HTTP
          # control channel"). Nothing here scrapes it, so unix socket only.
          control-sockets = [
            {
              socket-type = "unix";
              socket-name = "/run/kea/dhcp4.sock";
            }
          ];

          interfaces-config = {
            dhcp-socket-type = "raw";
            interfaces = [
              "lan"
              "isolated"
            ];

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
            {
              id = 2;
              subnet = "192.168.69.0/24";
              pools = [ { pool = "192.168.69.2 - 192.168.69.254"; } ];
              # overrides the global option-data, which points at the lan gateway
              option-data = [
                {
                  name = "routers";
                  data = "192.168.69.1";
                }
                {
                  name = "domain-name-servers";
                  data = "192.168.69.1";
                }
              ];
              # these hosts are unreachable from lan, so keep them out of the zone
              ddns-send-updates = false;
            }
          ];
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

  # lan is a trusted interface, isolated deliberately is not
  networking.firewall.interfaces.isolated.allowedUDPPorts = [ 67 ];
}
