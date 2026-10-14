{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [

    ../../nixos/dmsmobile.nix
    # Temporary: tee-fprintd in place of the libfprint focaltechqsee fprintd.
    inputs.tee-fprintd.nixosModules.default
  ];
  documentation.nixos.enable = false;
  environment = {
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
    ];
  };
  console.font = "solar24x32";

  vanilla-mobile.device.fairphone5 = {
    enable = true;
    fingerprint.enable = true;
  };
  services.tee-fprintd.enable = true;
  systemd.services.tee-fprintd = {
    after = [ "focal32-load.service" ];
    environment.TEE_FPRINTD_DEBUG = "1";
  };
  # Matches the partition labels of the image the phone was flashed with.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  boot.initrd.kernelModules = [ "panel-raydium-rm692e5" ];
  boot.kernelPatches = [
    {
      name = "sched-ext";
      patch = null;
      structuredExtraConfig.SCHED_CLASS_EXT = lib.kernel.yes;
    }
  ];

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
  };
  # Don't block boot ~9.5s waiting for wifi (ath11k rproc probe defers wlan0 late).
  systemd.services.NetworkManager-wait-online.enable = false;

  nix = {
    buildMachines = [
      {
        system = "aarch64-linux";
        sshUser = "marcus";
        hostName = "mstudio";
        protocol = "ssh-ng";
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 4;
      }
    ];
    settings = {
      max-jobs = 0;
    };
  };
  profiles = {
    dmsMobile.enable = true;
    myfonts.enable = true;
  };
  services = {
    desktopManager = {
      gnome.enable = true;
    };
    # GNOME brings power-profiles-daemon; vanilla-mobile defaults to TLP.
    tlp.enable = false;
  };
}
