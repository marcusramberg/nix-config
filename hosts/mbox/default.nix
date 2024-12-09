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
      # systemd = {
      #   network.enable = true;
      #   network.networks."10-wlan" = {
      #     matchConfig.Name = "enp9s0";
      #     networkConfig.DHCP = "yes";
      #   };
      # };
    };

    # kernelParams = [ "fbcon=map:1" ];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [
      "fbcon"
      "hid-apple"
    ];
    kernel.sysctl = {

      "fs.inotify.max_user_watches" = 2048576; # default: 8192
      "fs.inotify.max_user_instances" = 1024; # default: 128
      "fs.inotify.max_queued_events" = 32768; # default: 16384 };
    };
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options kvm_intel nested=1
    '';
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

  jovian = {
    decky-loader = {
      enable = true;
      user = "marcus";
    };
    hardware.has.amd.gpu = true;
    steamos = {
      enableBluetoothConfig = true;
      enableSysctlConfig = true;
      enableVendorRadv = true;
    };
    steam = {
      enable = true;
      user = "marcus";
      autoStart = true;
      desktopSession = "plasma";
    };
  };

  networking = {
    extraHosts = ''
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
    desktop.enable = true;
    dockerHost.enable = true;
    gaming.enable = true;
    k3s = {
      enable = true;
      staticIP = {
        enable = true;
        ip = "192.168.86.22";
      };
    };
  };

  programs = {
    custom.ddcutil = {
      enable = true;
      user = "marcus";
    };
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
    displayManager.sddm.enable = lib.mkForce false;
    # grafana-kiosk.enable = true;
    immich = {
      enable = true;
      host = "0.0.0.0";
      port = 8080;
      mediaLocation = "/space/immich";
      openFirewall = true;
      secretsFile = config.age.secrets.immich.path;
    };
    k3s = {
      clusterInit = true;
      serverAddr = "https://192.168.86.1:6443";
    };
    nomad = {
      enable = false;
      enableDocker = false;
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
