{ pkgs, lib, config, secrets, ... }: {
  age.secrets.vaultwarden.owner = "vaultwarden";
  age.secrets.miniflux.owner = "miniflux";
  age.secrets.transmission.owner = "transmission";

  services = {
    vaultwarden = {
      enable = true;
      config = {
        rocketPort = 8222;
        rocketLog = "critical";
      };
      environmentFile = config.age.secrets.vaultwarden.path;
    };
    caddy = {
      enable = true;
      globalConfig = ''
        http_port 18080
        https_port 18443
      '';
      virtualhosts."means.no" = {
        extraConfig = "" redirect "http://means.no" "https://means.no" "";

      };
      extraConfig = ''
          home.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy mhub.lan:8123
          }

          fab.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy fab.lan
          }

          files.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy mspace.lan
          }
          movies.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy localhost:7878
          }
          transmission.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy localhost:9091
          }

          nzb.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy localhost:6789
          }

         passwords.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy localhost:8222
          }

         rss.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            reverse_proxy localhost:8485
          }

         (caddy-common) {
           encode gzip
             header {
               -Server
                 Strict-Transport-Security "max-age=31536000; include-subdomains;"
                 X-XSS-Protection "1; mode=block"
                 X-Frame-Options "DENY"
                 X-Content-Type-Options nosniff
                 Referrer-Policy  no-referrer-when-downgrade
                 X-Robots-Tag "none"
             }
         }
         posta.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            import caddy-common
            reverse_proxy   http://localhost:1234

          @lemmy {
            path    /api/*
            path    /pictrs/*
            path    /feeds/*
            path    /nodeinfo/*
            path    /.well-known/*
          }

          @lemmy-hdr {
            header Accept application/*
          }

          handle @lemmy {
            reverse_proxy   http://localhost:8536
          }

          handle @lemmy-hdr {
            reverse_proxy   http://localhost:8536
          }

          @lemmy-post {
            method POST
          }
        handle @lemmy-post {
          reverse_proxy   http://localhost:8536
        }
        }


          tv.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
           reverse_proxy localhost:8989
          }

        unifi.means.no {
           tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
           reverse_proxy https://localhost:8443 {
             transport http {
               tls_insecure_skip_verify
               }
           }
         }

        www.tabdog.net {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            redir https://tabdog.net/ permanent
          }

          tabdog.net {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            root * /var/tabdog.net
            file_server /* browse
          }

          www.means.no {
            tls /etc/caddy/cloudflare.crt /etc/caddy/cloudflare.key
            root * /html
            file_server /* {
              browse
              index index.md
            }
          }
      '';
    };

    nzbget.enable = true;
    radarr.enable = true;
    sonarr.enable = true;

    miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux.path;
      config = {
        LISTEN_ADDR = "localhost:8485";
        METRICS_COLLECTOR = "1";
      };
    };

    transmission = {
      enable = true;
      downloadDirPermissions = "755";
      settings = {
        download-dir = "/space/incoming";
        incomplete-dir = "/var/lib/transmission/.incomplete";
        rpc-authentication-required = true;
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
        rpc-username = "marcus";
        umask = 0;
      };
      credentialsFile = config.age.secrets.transmission.path;
    };
    # services.unifi = {
    # enable = true;
    # openFirewall = true;
    # unifiPackage = pkgs.unifi6;
    # };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_13;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
  };

}

