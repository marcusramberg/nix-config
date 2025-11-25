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
    ../../nixos/calibre-web.nix
  ];

  # Bootloader.
  boot = {
    # binfmt.emulatedSystems = [ "aarch64-linux" ];
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
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".device =
        "/dev/disk/by-uuid/0050060b-f9cb-4697-8934-aef2f5ad0e2a";
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
    gurk-rs
    prusa-slicer
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
    "/mnt/nix" = {
      device = "/dev/nvme1n1p1";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=nix"
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
    fancontrol = {
      enable = true;
      config = ''
        INTERVAL=10
        DEVPATH=hwmon2=devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:00.0/0000:03:00.0
        DEVNAME=hwmon2=amdgpu
        FCTEMPS=hwmon2/pwm1=hwmon2/temp1_input
        FCFANS= hwmon2/pwm1=hwmon2/fan1_input
        MINTEMP=hwmon2/pwm1=30
        MAXTEMP=hwmon2/pwm1=60
        MINSTART=hwmon2/pwm1=68
        MINSTOP=hwmon2/pwm1=28
        MAXPWM=hwmon2/pwm1=150
      '';
    };
  };

  profiles = {
    autoupgrade.enable = true;
    desktop.enable = true;
    # dockerHost.enable = true;
    gaming.enable = true;
    caddy = {
      enable = true;
      configFile = ../../config/Caddyfile.mbox;
    };
    k3s = {
      enable = true;
      staticIP = {
        enable = true;
        ip = "192.168.86.22";
      };
    };
  };

  networking = {
    firewall.trustedInterfaces = [
      "incusbr0"
    ];
  };

  programs = {
    custom.ddcutil = {
      enable = true;
      user = "marcus";
    };
  };

  services = {
    blueman.enable = true;
    displayManager.sddm.enable = lib.mkForce false;
    immich = {
      enable = true;
      host = "0.0.0.0";
      mediaLocation = "/space/immich";
      database = {
        enableVectors = true;
        enableVectorChord = false;
      };
      openFirewall = true;
      secretsFile = config.age.secrets.immich.path;
    };
    jellyfin = {
      enable = true;
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
    postgresql.package = pkgs.postgresql_14;

    ollama = {
      host = "0.0.0.0";
      enable = true;
      openFirewall = true;
      # acceleration = "rocm";
    };
    tailscale.useRoutingFeatures = "server";
    woodpecker-agents.agents.mbox = {
      enable = true;
      environment = {
        WOODPECKER_SERVER = "passthrough:///ci-agent.bas.es:443";
        WOODPECKER_GRPC_SECURE = "true";
        WOODPECKER_BACKEND = "docker";
        DOCKER_HOST = "unix:///run/docker.sock";
        WOODPECKER_AGENT_LABELS = "!builder=x86,builder=x86";
        WOODPECKER_AGENT_CONFIG_FILE = "/var/lib/woodpecker/agent_config.yaml";
      };
      extraGroups = [ "docker" ];
      environmentFile = [ config.age.secrets.woodpecker-ci.path ];
    };
  };
  systemd.services = {
    caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";
    NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.networkmanager}/bin/nm-online -q"
        ];
      };
    };
    glance = {
      enable = true;
      description = "Glance";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${pkgs.glance}/bin/glance --config /var/lib/glance/glance.yaml";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  users.users.caddy.extraGroups = [ "incus-admin" ];
  virtualisation = {
    docker.enable = true;
    incus = {
      enable = true;
      ui.enable = true;

    };
    waydroid.enable = true;
  };
}
