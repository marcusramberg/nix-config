{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.profiles.mediaserver;
in
{
  # Comment this in to do a postgres upgrade before commenting out and bumping
  options.profiles.mediaserver.enable = mkEnableOption "Enable media server profile";

  config = mkIf cfg.enable {

    age.secrets = {
      vaultwarden.owner = "vaultwarden";
      miniflux = {
        group = "miniflux";
        owner = "miniflux";
      };
      transmission.owner = "transmission";
    };

    networking.firewall.allowedTCPPorts = [
      32400 # Plex
      40000 # Hass
      21064 # Hass Bridge
      1883 # MQTT
      35105 # aircast
      35185 # aircast
      50387 # aircast
    ];
    profiles.dockerHost.enable = true;

    services = {
      atuin = {
        enable = true;
        openRegistration = true;
        database.uri = "postgresql://atuin@localhost:5432/atuin";
      };
      vaultwarden = {
        enable = true;
        config = {
          rocketPort = 8222;
          rocketLog = "critical";
        };
        environmentFile = config.age.secrets.vaultwarden.path;
      };

      nzbget.enable = true;
      radarr = {
        enable = true;
        settings = {
          server.BindAddress = "127.0.0.1";
        };
      };

      sonarr.enable = true;
      readarr.enable = true;

      miniflux = {
        enable = true;
        adminCredentialsFile = config.age.secrets.miniflux.path;
        config = {
          LISTEN_ADDR = "localhost:8485";
          METRICS_COLLECTOR = "1";
          OAUTH2_PROVIDER = "oidc";
          OAUTH2_REDIRECT_URL = "https://rss.means.no/oauth2/oidc/callback";
          OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.means.no";
          OAUTH2_OIDC_PROVIDER_NAME = "PocketID";
          OAUTH2_USER_CREATION = 1; # optional, if you want nes users to be created automatically
          # DISABLE_LOCAL_AUTH=1 # optional, if you want to disable local authentication

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

      unifi = {
        enable = true;
        unifiPackage = pkgs.unifi;
        mongodbPackage = pkgs.mongodb-ce;
        openFirewall = true;
      };

      postgresql = {
        enable = true;
        package = pkgs.postgresql_16;
        enableTCPIP = true;
        authentication = pkgs.lib.mkOverride 10 ''
          local all all trust
          host all all ::1/128 trust
          host all all 127.0.0.1/32 trust
        '';
      };
    };

    users = {
      users = {
        radarr.extraGroups = [
          "transmission"
          "nzbget"
        ];
        sonarr.extraGroups = [
          "transmission"
          "nzbget"
        ];
        readarr.extraGroups = [
          "transmission"
          "nzbget"
        ];
        plex = {
          isNormalUser = false;
          description = "Plex";
          uid = 193;
          group = "plex";
        };
      };
      groups.plex.gid = 193;
    };

    virtualisation.oci-containers.containers = {
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        environment = {
          TZ = "Europe/Oslo";
          PUID = "193";
          PGID = "193";
          VERSION = "latest";
        };
        extraOptions = [
          "--net=host"
          "--device=/dev/dri/"
        ];
        volumes = [
          "/var/lib/plex:/config"
          "/space:/space"
        ];
      };
      minecraft = {
        image = "karlrees/docker_bedrockserver";
        extraOptions = [ "--network=host" ];
        volumes = [ "/var/lib/minecraft-bedrock:/mcdata" ];
      };
    };
    services.audiobookshelf = {
      enable = true;
      port = 5080;
    };
  };
}
