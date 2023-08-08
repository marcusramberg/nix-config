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

    # unifi = {
    #   enable = true;
    #   openFirewall = true;
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
  users.users.radarr.extraGroups = [ "transmission" "nzbget" ];
  users.users.sonarr.extraGroups = [ "transmission" "nzbget" ];

}

