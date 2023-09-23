{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.profiles.dockerHost;
in {

  options.profiles.dockerHost = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable docker host profile";
    };
  };

  config.virtualisation = mkIf cfg.enable {
    podman.enable = true;
    podman.dockerCompat = true;
    oci-containers.backend = "podman";
  };
}
