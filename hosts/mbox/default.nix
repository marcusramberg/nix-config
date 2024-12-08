{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  age.secrets.cloudflareToken.owner = "caddy";
  # Bootloader.
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".device = "/dev/disk/by-uuid/0050060b-f9cb-4697-8934-aef2f5ad0e2a";
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".keyFile = "/crypto_keyfile.bin";
      systemd = {
        network.enable = true;
        network.networks."10-wlan" = {
          matchConfig.Name = "enp9s0";
          networkConfig.DHCP = "yes";
        };
      };
    };

    kernelParams = [ "fbcon=map:1" ];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [
      "fbcon"
      "hid-apple"
    ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options kvm_intel nested=1
    '';
  };
  environment.etc = {
    "xrdp/sesman.ini".source = "${config.services.xrdp.confDir}/sesman.ini";
  };
  environment.systemPackages = with pkgs; [
    prusa-slicer
    cage
  ];

  fileSystems = {
    "/space" = {
      device = "mspace:/volume1/space";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
      ];
    };
    # "/photo" = {
    #   device = "mspace:/volume1/photo";
    #   fsType = "nfs4";
    #   options = [
    #     "nfsvers=4.1"
    #     "soft"
    #   ];
    # };
    "/home/marcus/org" = {
      device = "mspace:/volume1/homes/marcus/Drive/orgmode";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
      ];
    };
  };
  networking = {
    extraHosts = ''
      10.211.55.2 mbook
      0.0.0.0 vg.no www.vg.no
    '';
    hostName = "mbox";
    networkmanager.enable = true;
  };

  hardware = {
    gpu.amd.enable = true;
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
  };

  profiles = {
    autoupgrade.enable = true;
    doom.enable = true;
    nimdow.enable = true;
    hyprland.enable = true;
    dockerHost.enable = true;
    gaming.enable = true;
    k3s = {
      enable = true;
      staticIP = {
        enable = true;
        ip = "192.168.86.22";
      };
    };
    passthrough = {
      enable = true;
      hardware-ids = [
        "8086:1901"
        "10de:1f08"
        "10de:10f9"
        "10de:1ada"
        "10de:1adb" # nvidia
        "144d:a808" # NVME
        "10ec:8168" # network adapter
      ];
    };
  };

  programs = {
    custom.ddcutil = {
      enable = true;
      user = "marcus";
    };
  };

  programs.streamdeck-ui = {
    enable = false;
    autoStart = true;
  };

  services = {
    below = {
      enable = true;
      retention.size = 10000000;
    };
    blueman.enable = true;
    caddy = {
      enable = true;
      package = pkgs.caddy-cloudflare;
      configFile = ../../config/Caddyfile.mbox;
      adapter = "caddyfile";
    };
    k3s = {
      clusterInit = true;
      serverAddr = "https://192.168.86.22:6443";
    };
    nomad = {
      enable = true;
      enableDocker = false;
    };
    # grafana-kiosk.enable = true;
    immich = {
      enable = true;
      host = "0.0.0.0";
      port = 8080;
      mediaLocation = "/space/immich";
      openFirewall = true;
      secretsFile = config.age.secrets.immich.path;
    };
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };

    ollama = {
      host = "0.0.0.0";
      enable = true;
      # acceleration = "rocm";
    };
    tailscale.useRoutingFeatures = "server";

    displayManager.defaultSession = lib.mkForce "xfce+i3";

    # # Deckmaster
    # udev.extraRules = ''
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-mini"
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-xl"
    # '';
    #
    xrdp = {
      enable = true;
      audio.enable = true;
      defaultWindowManager = lib.mkForce "${pkgs.i3}/bin/i3";
    };
  };
  systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.networkmanager}/bin/nm-online -q"
      ];
    };
  };
  virtualisation = {
    # docker.enable = true;
    incus = {
      enable = true;
      ui.enable = true;
    };
    waydroid.enable = true;
  };
}
