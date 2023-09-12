{ config, ... }: {
  services.influxdb.enable = true;
  services.mosquitto = {
    enable = true;
    # listeners = [{
    #   acl = [ "pattern readwrite #" ];
    #   omitPasswordAuth = true;
    #   settings.allow_anonymous = true;
    # }];
    listeners = [{
      omitPasswordAuth = false;
      users = {
        hass = {
          acl = [ "readwrite homeassistant/#" ];
          passwordFile = config.age.secrets.mosquittoPass.path;
        };
      };
      # extraConf = "log_type debug";
    }];
  };
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
        image = "ghcr.io/home-assistant/home-assistant:2023.8.1";
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
      # docker run --name appdaemon  --detach --restart=always --network=host -p 5050:5050 -v <conf_folder>:/conf -e HA_URL="http://homeassistant.local:8123"  -e TOKEN="my_long_liven_token"  acockburn/appdaemon
      containers.appdaemon = {
        image = "acockburn/appdaemon:latest";
        environmentFiles = [ config.age.secrets.appdaemonToken.path ];
        extraOptions = [ "--net=host" ];
        volumes = [ "/var/lib/appdaemon:/conf" ];
      };
      containers.aircast = {
        image = "docker.io/1activegeek/airconnect:latest";
        extraOptions = [ "--net=host" ];
      };
    };
  };
}

