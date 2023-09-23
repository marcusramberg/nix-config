{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.hardware.amdgpu;
in {
  options.hardware.amdgpu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Set machine up for AMD GPU";
    };
  };

  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load amd driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "amdgpu" ];

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
