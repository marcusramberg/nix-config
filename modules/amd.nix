{ config, lib, ... }:
with lib;
let cfg = config.hardware.amdgpu;
in {
  options.hardware.amdgpu.enable = mkEnableOption "amdgpu";

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
