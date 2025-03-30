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

      unifi = {
        enable = true;
        unifiPackage = pkgs.unifi8;
        mongodbPackage = pkgs.mongodb-ce;
        openFirewall = true;
      };

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
