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
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.spanner-cli
    ])
    plexamp
    slack
    spotify
    woodpecker-cli
    ssh-tpm-agent
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
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-id/usb-Logitech_USB_Receiver-event-kbd"
          "/dev/input/by-id/usb-SDINNOVATION_Gaming_Keyboard_003123456789-event-kbd"
        ];
      };
    };
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.libglvnd
        pkgs.mesa
        pkgs.mesa.drivers
      ];
    };
  };

  # fprintd fails to suspend cleanly ("still busy with another operation") which
  # leaves a stale device claim after resume. Fix: stop it cleanly before sleep
  # so the device is released properly; it re-initialises on demand after wake.
  systemd.services = {
    printd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
    fprintd-sleep = {
      description = "Stop fprintd before sleep, restart after resume";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "/run/current-system/sw/bin/systemctl stop fprintd.service";
        ExecStop = "/run/current-system/sw/bin/systemctl start fprintd.service";
      };
    };
  };

  # Install the driver
  services = {
    fprintd.enable = true;
    resolved = {
      enable = true;
      settings.Resolve = {
        MulticastDNS = false;
      };

    };
    xserver.xkb.variant = lib.mkForce "mac-iso";
  };
  security.pam.services = {
    greetd.fprintAuth = false;
    login.unixAuth = true;
    login.fprintAuth = false;
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

  profiles = {
    incus.enable = true;
    limine = {
      enable = true;
      secureboot = true;
    };
  };
  services = {
    knot.enable = true;
    cloudflare-warp.enable = true;
    udev.extraRules = ''
      # DFU (Internal bootloader for STM32 and AT32 MCUs)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"

      SUBSYSTEM=="usb",  ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5020", MODE="0666"
      # FIXME: the following line is not sufficient for pyhidapi.
      KERNEL=="hidraw*", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5020", ATTRS{busnum}=="1", MODE="0666"

      # power management for  x1 fprint sensor
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="00fc", TEST=="power/control", ATTR{power/control}="on"

    '';
  };
  systemd.sleep.settings.Sleep = {
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };
  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
    podman.enable = true;
  };
}
