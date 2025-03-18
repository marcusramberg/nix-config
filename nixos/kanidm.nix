{ pkgs, ... }:
let
  certsDirectory = "/var/lib/caddy/.local/share/caddy";
in
{
  services = {
    kanidm = {
      enableServer = true;
      package = pkgs.kanidm_1_5;

      serverSettings = {
        bindaddress = "127.0.0.1:4554";
        ldapbindaddress = "0.0.0.0:1636";

        domain = "auth.means.no";
        origin = "https://auth.means.no";

        tls_chain = "${certsDirectory}/certificates/acme-v02.api.letsencrypt.org-directory/auth.means.no/auth.means.no.crt";
        tls_key = "${certsDirectory}/certificates/acme-v02.api.letsencrypt.org-directory/auth.means.no/auth.means.no.key";
      };

      enableClient = true;
      clientSettings.uri = "https://auth.means.no";
    };

  };
  networking.firewall.allowedTCPPorts = [ 636 ];
  systemd.services.kanidm = {
    serviceConfig.SupplementaryGroups = [ "caddy" ];
  };
  users.groups.acme = { };

  security.acme = {
    defaults = {
      email = "marcus@means.no";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/run/agenix/dns";
    };

    acceptTerms = true;
  };

}
