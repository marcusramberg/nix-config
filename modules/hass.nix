{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.profiles.hass;
in {
  options.profiles.hass = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable home assistant server";
    };
  };

  config = mkIf cfg.enable {

    profiles.dockerHost.enable = true;

    services = {
      influxdb.enable = true;
      mosquitto = {
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
    };
    virtualisation.oci-containers.containers = {
      hass = {
        # renovate: datasource=docker depName=homeassistant/home-assistant
        image = "ghcr.io/home-assistant/home-assistant:2023.9.2";
        environment = { TZ = "Europe/Oslo"; };
        extraOptions = [
          "--net=host"
          "--device=/dev/serial/by-id/usb-0658_0200-if00"
          "--privileged"
        ];
        volumes = [ "/var/lib/homeassistant:/config" ];
      };
      zwave-js-ui = {
        # renovate: datasource=docker depName=zwave-js/zwave-js-ui
        image = "ghcr.io/zwave-js/zwave-js-ui:8.25.1";
        volumes = [
          "/var/lib/zwave-js-ui:/usr/src/app/store"
          "/dev:/dev"
          "/run/udev:/run/udev"
        ];
        extraOptions = [ "--net=host" "--privileged" ];
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
