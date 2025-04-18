# Auto-generated using compose2nix v0.3.2-pre.
{
  pkgs,
  lib,
  config,
  ...
}:

{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    oci-containers = {
      backend = "podman";
      containers."calibre-web-automated" = {
        image = "crocodilestick/calibre-web-automated:latest";
        environment = {
          "PGID" = "1000";
          "PUID" = "1000";
          "TZ" = "UTC";
        };
        volumes = [
          "/var/lib/calibre-web:/config:rw"
          "/space/incoming/books:/cwa-book-ingest:rw"
          "/space/calibre:/calibre-library:rw"
        ];
        ports = [
          "8083:8083/tcp"
        ];
        log-driver = "journald";
        extraOptions = [
          "--network-alias=calibre-web-automated"
          "--network=calibre_web_default"
        ];
      };
    };
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces =
    let
      matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
    in
    {
      "${matchAll}".allowedUDPPorts = [ 53 ];
    };

  # Containers
  systemd.services = {
    "podman-calibre-web-automated" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-calibre_web_default.service"
      ];
      requires = [
        "podman-network-calibre_web_default.service"
      ];
      partOf = [
        "podman-compose-calibre_web-root.target"
      ];
      wantedBy = [
        "podman-compose-calibre_web-root.target"
      ];
    };

    # Networks
    "podman-network-calibre_web_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f calibre_web_default";
      };
      script = ''
        podman network inspect calibre_web_default || podman network create calibre_web_default
      '';
      partOf = [ "podman-compose-calibre_web-root.target" ];
      wantedBy = [ "podman-compose-calibre_web-root.target" ];
    };
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-calibre_web-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
