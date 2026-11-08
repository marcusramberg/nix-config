{ config, lib, ... }:
with lib;
let
  cfg = config.profiles.dockerHost;
in
{

  options.profiles.dockerHost.enable = mkEnableOption "dockerHost";

  config = mkIf cfg.enable {
    virtualisation.containers.registries.settings.unqualified-search-registries = [ "docker.io" ];

    virtualisation = {
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
