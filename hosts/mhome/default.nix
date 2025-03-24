{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    initrd.availableKernelModules = [
      "ohci_pci"
      "ehci_pci"
      "ahci"
      "firewire_ohci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [
      "kvm-intel"
      "wl"
    ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  disko.devices.disk.sda = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          device = "/dev/sda1";
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
    };
    pulseaudio.enable = true;
  };
  programs.dconf.enable = true;
  services.pipewire.enable = false;
  services.xserver = {
    videoDrivers = [ "nvidiaLegacy340" ];
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (
        p: with p; [
          kodi-platform
          youtube
        ]
      );
    };
    displayManager = {
      lightdm = {
        enable = true;
        greeters.tiny.enable = true;
      };
      defaultSession = "kodi";
      autoLogin.enable = true;
      autoLogin.user = "marcus";
    };
  };

}
