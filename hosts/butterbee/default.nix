{ config, lib, modulesPath, options, secrets, ... }:

{
  networking.hostName = "butterbee"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.flatpak.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  networking.extraHosts = ''
    10.211.55.2 mbook
  '';
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services.nix
    ];
}
