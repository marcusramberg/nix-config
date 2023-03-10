{ config, ... }: {
  config = {
    services.influxdb.enable = true;
    services.mosquitto = {
      enable = true;
      listeners = [{
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }];
    };
    # listeners = [ {
    #   omitPasswordAuth = true;
    #   users = { 
    #     hass = {
    #       acl = [ "readwrite homeassistant/#" ]; 
    #       password = secrers.mosquitto_pass; 
    #     }; 
    #   };
    # # extraConf = "log_type debug";
    # }];
    # };
    users.groups.plex.gid = 193;
    users.users.plex = {
      isNormalUser = false;
      description = "Plex";
      uid = 193;
      group = "plex";
    };
    virtualisation = {
      podman.enable = true;
      podman.dockerCompat = true;
      oci-containers = {
        backend = "podman";
        containers.hass = {
          # renovate: datasource=docker depName=homeassistant/home-assistant versioning=docker
          image = "ghcr.io/home-assistant/home-assistant:2023.3.3";
          environment = { TZ = "Europe/Oslo"; };
          extraOptions = [
            "--net=host"
            "--device=/dev/serial/by-id/usb-0658_0200-if00"
            "--privileged"
          ];
          volumes = [ "/var/lib/homeassistant:/config" ];
        };
        containers.zwave-js-ui = {
          # renovate: datasource=docker depName=zwave-js/zwave-js-ui versioning=docker
          image = "ghcr.io/zwave-js/zwave-js-ui:8.10.1";
          volumes = [
            "/var/lib/zwave-js-ui:/usr/src/app/store"
            "/dev:/dev"
            "/run/udev:/run/udev"
          ];
          extraOptions = [ "--net=host" "--privileged" ];
        };
        containers.minecraft = {
          image = "karlrees/docker_bedrockserver";
          extraOptions = [ "--network=host" ];
          volumes = [ "/var/lib/minecraft-bedrock:/mcdata" ];
        };
        containers.ubooquity = {
          image = "lscr.io/linuxserver/ubooquity";
          extraOptions = [ "--network=host" ];
          volumes = [ "/var/lib/ubooquity:/config" "/space/Comics:/comics" ];
        };
        containers.plex = {
          image = "plexinc/pms-docker:plexpass";
          environment = {
            TZ = "Europe/Oslo";
            PLEX_UID = "193";
            PLEX_GID = "193";
          };
          extraOptions = [ "--net=host" "--device=/dev/dri/" ];
          volumes = [ "/var/lib/plex:/config" "/space:/space" ];
        };
        containers.zigbee2mqtt = {
          image = " ghcr.io/koenkk/zigbee2mqtt:latest-dev";
          extraOptions = [ "--privileged" "--network=host" ];
          volumes = [
            "/dev:/dev"
            "/run/udev:/run/udev"
            "/var/lib/zigbee2mqtt:/app/data"
          ];
        };
      };
    };
  };
}

