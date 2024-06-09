{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hardware-configuration.nix
  ];
  # Enable hardware and Steam support.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  jovian = {
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
      enableXorgRotation = false;
    };
    steam = {
      enable = true;
      user = "marcus";
      autoStart = true;
      desktopSession = "xfce+i3";
    };
  };

  environment.systemPackages = with pkgs; [
    galileo-mura
    steamdeck-firmware
    jupiter-dock-updater-bin
    mangohud
  ];

  # Automount SD card.
  fileSystems."/run/media/deck/mmcblk0p1" = {
    device = "/dev/mmcblk0p1";
    options = [
      "defaults"
      "rw"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=1ms"
      "comment=x-gvfs-show"
    ];
  };
  profiles.desktop.enable = true;

  # Symlink old Steam Deck SD card path to new one.
  systemd.tmpfiles.rules = [ "L+ /run/media/mmcblk0p1 - - - - /run/media/deck/mmcblk0p1" ];

  networking.hostName = "deck";

  services = {
    xserver.displayManager.lightdm.enable = lib.mkForce false;
    # flatpak.enable = true;
    input-remapper.enable = true;
  };

}
