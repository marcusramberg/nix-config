{ config, lib, ... }:
with lib;
let
  cfg = config.profiles.dockerHost;
in
{

  options.profiles.dockerHost.enable = mkEnableOption "dockerHost";

  config = mkIf cfg.enable {
    environment.etc."containers/registries.conf".text = ''
      [registries.search]
      registries = ['docker.io']
    '';

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
