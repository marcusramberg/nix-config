{ config, lib, ... }:
with lib;
let cfg = config.hardware.gpu.amd;
in {
  options.hardware.gpu.amd.enable = mkEnableOption "Enable config for amd gpu";

  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load amd driver for Xorg and Wayland
    # services.xserver.videoDrivers = [ "amdgpu" ];

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
