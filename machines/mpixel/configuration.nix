{ pkgs, lib, ... }:
{
  imports = [

    ../../nixos/dmsmobile.nix
  ];

  boot.kernelParams = [ "exynos_gsa.gsc_version=1" ];
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 5;
  documentation.nixos.enable = false;
  environment = {
    sessionVariables.WLR_RENDER_DRM_DEVICE = "/dev/dri/by-path/platform-1f000000.gpu-render"; # panthor, stable across probe order
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
      tastiera
    ];
  };

  hardware = {
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
    pixel9pro = {
      audio.enable = true;
      bluetooth.enable = true;
      display.enable = true;
      modem = {
        enable = true;
        modemManager = true;
      };
      sensors.enable = true;
      wifi = {
        enable = true;
        driver = "brcmfmac"; # TEMP: btc_mode A/B for the wl2 trap, AGENTS.md §3
      };
    };
    sensor.iio.enable = true;

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
  };
}
