{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf".device =
      "/dev/disk/by-uuid/1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf";
  };

  environment.systemPackages = with pkgs; [
    spotify
    ssh-tpm-agent
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    keyboard.dual-caps = {
      enable = true;
      swapAlt = {
        enable = true;
        devices = [
          "/dev/input/by-id/usb-SDINNOVATION_Gaming_Keyboard_003123456789-event-kbd"
          "/dev/input/by-path/pci-0000:00:14.0-usb-0:13.2:1.1-event-kbd"
          "/dev/input/by-id/logitech.input-event-kbd"
        ];
      };
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "mdesk";
  };

  profiles = {
    incus.enable = true;
    work.enable = true;
  };

  services.xserver.xkb.variant = lib.mkForce "mac-iso";

  system.activationScripts = {
    makeQuiet.text = ''
      echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
      echo 75 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
      echo 10 > /sys/class/thermal/cooling_device38/cur_state
    '';
  };

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
    podman.enable = true;
  };

}
