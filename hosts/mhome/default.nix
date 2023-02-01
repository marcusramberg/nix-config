{ config, lib, modulesPath, options }:

{
  networking.hostName = "mhome"; # Define your hostname.
  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [ "pcie_aspm=off" ];
  boot.loader.systemd-boot.enable = true;
}
