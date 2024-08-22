{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];
  networking.hostName = "butterbee"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = false;

  profiles = {
    desktop.enable = true;
    dockerHost.enable = true;
    hyprland.enable = true;
  };

  services = {
    flatpak.enable = true;
    displayManager.sddm.enableHidpi = true;
    cloudflare-warp.enable = true;
    xserver.dpi = 140;
  };
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.user.services.warp-taskbar.wantedBy = [ "graphical.target" ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  networking.extraHosts = ''
    10.211.55.2 mbook
    0.0.0.0 vg.no www.vg.no
  '';
}
