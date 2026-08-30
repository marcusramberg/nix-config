{ pkgs, lib, ... }:
{
  imports = [

    ../../nixos/dmsmobile.nix
  ];
  documentation.nixos.enable = false;
  environment = {
    variables.GTK_IM_MODULE = lib.mkForce "wayland";
    sessionVariables.WLR_RENDER_DRM_DEVICE = "/dev/dri/by-path/platform-1f000000.gpu-render"; # panthor, stable across probe order
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
    ];
  };

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
    pixel9pro = {
      display.enable = true;
      wifi = {
        enable = true;
        driver = "bcmdhd"; # FIXME:  We want brcmfmac but it's broken
      };
      modem = {
        enable = true;
        modemManager = true;
      };
      sensors.enable = true;
    };
  };

  # Gotta shut this off until we get proper early drm
  boot.plymouth.enable = false;

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
