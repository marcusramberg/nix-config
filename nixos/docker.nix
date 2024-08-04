{ config, lib, ... }:
with lib;
let
  cfg = config.profiles.dockerHost;
in
{

  options.profiles.dockerHost.enable = mkEnableOption "dockerHost";

  config.virtualisation = mkIf cfg.enable {
    podman.enable = true;
    podman.dockerCompat = true;
    oci-containers.backend = "podman";
  };
}
