{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.luks.devices."luks-9de8d567-1ec4-4d2f-896b-a0f6711d4d44".device =
      "/dev/disk/by-uuid/9de8d567-1ec4-4d2f-896b-a0f6711d4d44";
  };
  environment.systemPackages = with pkgs; [
    act
    amazon-ecr-credential-helper
    docker-credential-gcr
    google-cloud-sdk # .withExtraComponents [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    slack
    spotify
    woodpecker-cli
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    keyboard.dual-caps = {
      enable = true;
      swapAlt = {
        enable = true;
        device = "platform-i8042-serio-0-event-kbd";
      };
    };
  };

  # fingerprint readre
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # Install the driver
  services = {
    fprintd = {
      enable = true;
    };
    envfs.enable = true;
    resolved = {
      enable = true;
      extraConfig = ''
        MulticastDNS=No
      '';
    };
    xserver.xkb.variant = lib.mkForce "mac-iso";
  };
  security.pam.services = {
    login.unixAuth = true;
    login.fprintAuth = false;
    sddm.fprintAuth = false;
    kwallet.fprintAuth = true;
  };

  # Enable networking
  networking = {
    networkmanager = {
      appendNameservers = [ "1.1.1.1" ];
      dns = "systemd-resolved";
      enable = true;
      plugins = lib.mkForce [ ];
      wifi.backend = "iwd";
    };
  };
  networking.firewall.enable = false;
  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        distroav
        obs-teleport
        wlrobs
        pixel-art
        obs-vaapi
      ];
    };
  };

  powerManagement.enable = true;
  profiles = {
    limine = {
      enable = true;
      secureboot = true;
    };
  };
  services = {
    cloudflare-warp.enable = true;
    udev.extraRules = ''
      # DFU (Internal bootloader for STM32 and AT32 MCUs)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
    '';
  };
  systemd.sleep.extraConfig = ''
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };
}
