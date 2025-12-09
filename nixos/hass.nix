{ lib, config, ... }:
with lib;
let
  cfg = config.profiles.hass;
in
{
  options.profiles.hass.enable = mkEnableOption "Enable home assistant server";

  config = mkIf cfg.enable {

    profiles.dockerHost.enable = true;

    networking.firewall.allowedTCPPorts = [
      8123
    ];
    services = {
      influxdb.enable = true;
      mosquitto = {
        enable = true;
        listeners = [
          {
            omitPasswordAuth = false;
            users = {
              hass = {
                acl = [
                  "readwrite homeassistant/#"
                  "readwrite zigbee2mqtt/#"
                ];
                passwordFile = config.age.secrets.mosquittoPass.path;
              };
            };
            # extraConf = "log_type debug";
          }
        ];
      };
    };
    virtualisation.oci-containers.containers = {
      hass = {
        # renovate: datasource=docker depName=homeassistant/home-assistant
        image = "ghcr.io/home-assistant/home-assistant:2025.12.2";
        environment = {
          TZ = "Europe/Oslo";
        };
        extraOptions = [
          "--net=host"
          "--privileged"
        ];
        volumes = [
          "/var/lib/homeassistant:/config"
          "/dev:/dev"
          "/dev/null:/.dockerenv"
          "/run/udev:/run/udev"
        ];
      };
      zwave-js-ui = {
        # renovate: datasource=docker depName=zwave-js/zwave-js-ui
        image = "ghcr.io/zwave-js/zwave-js-ui:11.8.2";
        volumes = [
          "/var/lib/zwave-js-ui:/usr/src/app/store"
          "/dev:/dev"
          "/run/udev:/run/udev"
        ];
        extraOptions = [
          "--net=host"
          "--privileged"
        ];
      };
      zigbee2mqtt = {
        # renovate: datasource=docker depName=koenkk/zigbee2mqtt
        image = " ghcr.io/koenkk/zigbee2mqtt:2.0.0";
        extraOptions = [
          "--privileged"
          "--network=host"
        ];
        volumes = [
          "/var/lib/zigbee2mqtt:/app/data"
        ];
      };

      aircast = {
        image = "docker.io/1activegeek/airconnect:latest";
        extraOptions = [ "--net=host" ];
      };
      appdaemon = {
        image = "acockburn/appdaemon:latest";
        environmentFiles = [ config.age.secrets.appdaemonToken.path ];
        extraOptions = [ "--net=host" ];
        volumes = [ "/var/lib/appdaemon:/conf" ];
      };
    };
  };
}
