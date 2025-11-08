{ config, lib, ... }:
let
  cfg = config.hardware.gpu.amd;
in
{
  options.hardware.gpu.amd.enable = lib.mkEnableOption "Enable config for amd gpu";

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics.enable = true;

    # Load amd driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "amdgpu" ];

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
