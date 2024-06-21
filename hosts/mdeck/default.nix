{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Enable hardware and Steam support.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  jovian = {
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
    };
    steam = {
      enable = true;
      user = "marcus";
      autoStart = true;
      desktopSession = "gnome-xorg";
    };
  };

  environment.systemPackages = with pkgs; [
    galileo-mura
    steamdeck-firmware
    jupiter-dock-updater-bin
    heroic
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

  hardware.keyboard.dual-caps.enable = true;

  profiles.desktop.enable = true;

  programs.steam = {
    enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [ gnome-tour ];

  # Symlink old Steam Deck SD card path to new one.
  systemd.tmpfiles.rules = [ "L+ /run/media/mmcblk0p1 - - - - /run/media/deck/mmcblk0p1" ];

  networking.hostName = "mdeck";
  networking.networkmanager.enable = true;

  services = {
    flatpak.enable = true;
    input-remapper.enable = true;
    xserver = {
      enable = true;
      displayManager.lightdm.enable = lib.mkForce false;
      displayManager.startx.enable = true;
      excludePackages = with pkgs; [ xterm ];
    };
  };

}
