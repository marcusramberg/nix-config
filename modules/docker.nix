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
          # renovate: datasource=docker depName=homeassistant/home-assistant
          image = "ghcr.io/home-assistant/home-assistant:2023.5.3";
          environment = { TZ = "Europe/Oslo"; };
          extraOptions = [
            "--net=host"
            "--device=/dev/serial/by-id/usb-0658_0200-if00"
            "--privileged"
          ];
          volumes = [ "/var/lib/homeassistant:/config" ];
        };
        containers.zwave-js-ui = {
          # renovate: datasource=docker depName=zwave-js/zwave-js-ui
          image = "ghcr.io/zwave-js/zwave-js-ui:8.15.0";
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
          image = "lscr.io/linuxserver/plex:latest";
          environment = {
            TZ = "Europe/Oslo";
            PUID = "193";
            PGID = "193";
          };
          extraOptions = [ "--net=host" "--device=/dev/dri/" ];
          volumes = [ "/var/lib/plex:/config" "/space:/space" ];
        };
        containers.zigbee2mqtt = {
          # renovate: datasource=docker depName=koenkk/zigbee2mqtt
          image = " ghcr.io/koenkk/zigbee2mqtt:1.30.2";
          extraOptions = [ "--privileged" "--network=host" ];
          volumes = [
            "/dev:/dev"
            "/run/udev:/run/udev"
            "/var/lib/zigbee2mqtt:/app/data"
          ];
        };
        containers.lemmy-server = {
          image = "dessalines/lemmy:0.17.3";
          extraOptions = [ "--network=host" ];
          environment = {
            RUST_LOG =
              "warn,lemmy_server=info,lemmy_api=info,lemmy_api_common=info,lemmy_api_crud=info,lemmy_apub=info,lemmy_db_schema=info,lemmy_db_views=info,lemmy_db_views_actor=info,lemmy_db_views_moderator=info,lemmy_routes=info,lemmy_utils=info,lemmy_websocket=info";
            RUST_BACKTRACE = "full";
          };
          volumes = [ "/var/lib/lemmy/lemmy.hjson:/config/config.hjson" ];
        };
        containers.pictrs = {
          image = "asonix/pictrs:0.3.1";
          environmentFiles = [ config.age.secrets.picserver.path ];
          ports = [ "4585:8080" ];
          volumes = [ "/space/pictrs:/mnt" ];
        };

        containers.lemmy-ui = {
          image = "dessalines/lemmy-ui:0.17.3";
          extraOptions = [ "--network=host" ];
          environment = {
            LEMMY_UI_LEMMY_INTERNAL_HOST = "localhost:8536";
            LEMMY_UI_LEMMY_EXTERNAL_HOST = "posta.no:1236";
            LEMMY_HTTPS = "true";
          };
        };
      };
    };
  };
}

