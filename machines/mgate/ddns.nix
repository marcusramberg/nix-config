{ lib, pkgs, ... }:
{
  services = {
    knot = {
      enable = true;
      settings = {
        server.listen = "127.0.0.1@5353";

        acl.dhcp_ddns = {
          address = "127.0.0.1";
          action = "update";
        };

        zone.lan = {
          file =
            let
              toRecord = { hostname, ip-address, ... }: "${hostname} A ${ip-address}";
              records = map toRecord (import ./dhcp-hosts.nix);
            in
            pkgs.writeText "lan.zone" ''
              @ SOA mgate mgate.pig-crested.ts.net 0 86400 7200 4000000 11200
              @ NS mgate.lan
              mgate A 192.168.86.1
              ${lib.concatStringsSep "\n" records}
            '';
          acl = [ "dhcp_ddns" ];
          zonefile-sync = "-1"; # don't write the zonefile to disk
          zonefile-load = "difference-no-serial"; # but do load from disk
          journal-content = "all"; # and write changes to journal
        };
      };
    };

    kea = {
      dhcp4.settings = {
        dhcp-ddns.enable-updates = true;
        ddns-send-updates = true;
        ddns-update-on-renew = true;
        ddns-qualifying-suffix = "lan.";
      };

      dhcp-ddns = {
        enable = true;
        settings.forward-ddns.ddns-domains = [
          {
            name = "lan.";
            dns-servers = [
              {
                ip-address = "127.0.0.1";
                port = 5353;
              }
            ];
          }
        ];
      };
    };
  };
}
