{ config, pkgs, ... }:
{
  services.atticd = {
    enable = true;
    settings = {
      listen = "[::]:14080";
      allowed-hosts = [
        "cache.bas.es"
        "localhost:14080"
      ];
      api-endpoint = "https://cache.bas.es/";

      # Storage
      storage = {
        type = "local";
        path = "/var/lib/atticd/storage";
      };

      # Enable compression
      compression.type = "zstd";
      # Garbage collection
      garbage-collection = {
        interval = "12 hours";
        default-retention-period = "30 days";
      };

    };
    environmentFile = config.age.secrets.atticd.path;
  };
  users.users.atticd = {
    isSystemUser = true;
    description = "Attic Daemon User";
    home = "/var/lib/atticd";
    createHome = true;
    group = "atticd";
    shell = pkgs.lib.mkForce pkgs.bashInteractive;
  };
  users.groups.atticd = { };
}
