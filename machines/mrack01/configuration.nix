{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./attic.nix
    ./disko.nix
    # ./forgejo.nix
    ./minecraft.nix
    ./woodpecker.nix
  ];
  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "mpt3sas"
      "isci"
      "usbhid"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  networking = {
    useDHCP = false;
    firewall = {
      allowedTCPPorts = [
        22
        80
        443
      ];
      enable = lib.mkForce true;
      logRefusedConnections = false;
    };
    hostId = "8fbe374d";
    nftables.enable = true;
    useNetworkd = true;
    wg-quick.interfaces.hack = {
      privateKeyFile = config.age.secrets.wg-mrack01.path;
      address = [
        "10.10.235.30/32"
        "2a02:ed06:235::1e/128"
      ];
      peers = [
        {
          endpoint = "185.35.202.235:443";
          publicKey = "z8//zcFn8o9MWhC0J+tuHD6aYbN9yZOKWxqwI9uB7WI=";

          ## Internal Networks (default)
          allowedIPs = [
            "10.10.3.0/24"
            "10.10.50.0/24"
          ];
        }
      ];

      ## External Networks (except the Peer Endpoint), and Internal Networks
      #allowedIPs = "2a02:ed06::/32, 10.10.3.0/24, 10.10.50.0/24, 185.35.202.192/27, 185.35.202.224/29, 185.35.202.232/31, 185.35.202.234/32, 185.35.202.236/30, 185.35.202.240/28";
      ## Route all IPv4 and IPv6 traffic
      #allowedIPs = "0.0.0.0/0, ::0/0";
    };
  };
  profiles = {
    caddy = {
      enable = true;
      configFile = ../../config/Caddyfile.mrack01;
    };
    dockerHost.enable = true;
    incus.enable = true;
  };
  services = {
    borgbackup.jobs = {
      varBackup = {
        paths = "/var";
        exclude = [
          "/var/cache"
          "/var/lib/containers"
          "/var/log"
          "/var/lib/lxcfs"
          "/var/lib/prometheus2/data/"
        ];
        repo = "marcus@mspace:/volume1/NetBackup/mrack01/var";
        doInit = true;
        encryption = {
          mode = "repokey";
          passCommand = "cat ${config.age.secrets.borgbackup.path}";
        };
        compression = "auto,lzma";
        startAt = "weekly";
      };
      localBackup = {
        paths = "/backup";
        exclude = [
          "/backup/immich"
        ];
        repo = "marcus@mspace:/volume1/NetBackup/mrack01/backup";
        doInit = true;
        encryption = {
          mode = "repokey";
          passCommand = "cat ${config.age.secrets.borgbackup.path}";
        };
        compression = "auto,lzma";
        startAt = "weekly";
      };
    };
    fail2ban = {
      enable = true;
      ignoreIP = [ "100.64.0.0/10" ];
      banaction = "nftables-multiport";
      banaction-allports = "nftables-allport";
      packageFirewall = pkgs.nftables;
      maxretry = 5;
      bantime = "15m";
      jails = {
        sshd.settings = {
          mode = "aggressive";
          port = "22";
        };
      };
    };
    pocket-id = {
      enable = true;
      credentials = {
        ENCRYPTION_KEY = config.age.secrets.pocket-id.path;
      };
      settings = {
        APP_URL = "https://auth.means.no";
        TRUST_PROXY = true;
      };
    };
    prometheus.exporters.node = {
      enable = true;
      openFirewall = false;
    };
    openssh.settings.PasswordAuthentication = false;
    tailscale.useRoutingFeatures = "server";

  };
  systemd.network = {
    wait-online.enable = false;
    enable = true;
    networks = {
      public = {
        enable = true;
        matchConfig.Name = "eno1";
        DHCP = "no";
        addresses = [
          { Address = "185.35.202.216/26"; }
          { Address = "2a02:ed06::216/64"; }
        ];
        routes = [
          { Gateway = "185.35.202.193"; }
          { Gateway = "2a02:ed06::1"; }

        ];
      };
      # private = {
      #   matchConfig.Name = "eno1";
      #   DHCP = "yes";
      # };
    };
  };
  systemd.services.zfs-mount.enable = false;
  users.users = {
    arne = {
      description = "Arne Fismen";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      uid = 1002;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkHOi39HCigHCOneTKIiY+C809n6d3sNHd3hoy2Uq21"
      ];
    };
    jhthorsen = {
      isNormalUser = true;
      description = "Batman";
      uid = 1001;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYdgI7mui35jULsNMHkYHmpNWhccPFHFjrD89RgZMfmjeOX1FD1c2eu036V/UzVJxRveP9n3LsWt2BjTewDIbR49VOJSQUxvVN5eC1YsCdTZQiHEXePdhFRberWk5c/tdk1CimwqRfMzoZlmguATqtFx0RuuKkxhm0bp3NW/1CPFgvGK3IWukF1nJZjupsCcN9bmpLMwK171dYL3+WdjHPtjNkzUmLqZ8qYGvAnD8KC+H8a1AhAtHIqvK10Xgtot30QCieaBdQjUhzCfRLlyH7koOsPkYL8aMi6Oqn0LTfOl44fecEWadgF6C4f3i4UctWJmjh8q67zNvsDg5apo1wo8YMUg/5VkLHovn5nkp+OWtXKAt38dCht3iffpIMnayMx2peq+i5kCoCdJTIGZt1R/CniCtfrdaU0xIIjurhrV0VgTvVEztAdbo6jM/JEWknpbxn85kR1Gw1TkN11mqz8B4vl1ewZfFweC2l/LYniDiobY5kZD9wz0PoZx9v/3AKjK836t58V77qrueK/ltm8ar9x1K1QJCPrq4q3NCkeqdf/oH7icIOAoKxWNvqhZcYhf5s0sUo5RDEm+Pgz7VmM6vuhkN1DOQykzfP8uca6RFd2pW25fOXECiEftxurORLo2QO4WXavkvS1xccFtO/XAh02waFLsf64rXfrYZfbw== jhthorsen@cpan.org"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5nk6X1vCz724VJ9a7erW8KBRRU8daBTHpvq366yd6FY3D4CWcfBp1syUOsVfnRY+ZWoCGXuQwlJm7Hn/MTH+8ORaycOflkTkX4FN3QTp4Id9j+1JDqryRmqn4j/7j9Gh13NEXGi70QCI+XJdc+mG71BADLlcgUE+YGJvgVyNjkDc0h3kLVMZTU3cZ/DtewFStANDQcchZyHzfPUgOdGN3Zrh1rfod+SELCDcivo1MwJIvY90ugXKv9YuQVcQlGwG6djwM6Mxk5S0WJaR1D2hMQBfNkZHRQP/nBSCU6811Z6TOQDZc9YvB3YlN8VVD2TA2x4aAp9E8+XLSvzz1G8QbxnExqU3DnM74J+Fb1kREFMHT4teP3VC+DWzIzp2F6LSawdskl2LaUFmsqsGzpoBhToDTayTjA1jkgxu5kYHwBru6kpKV4tWM1FJnD+rT9IgQvhHif8+DO5S4E5P9hUKPJHs7e3rDDr2Li23aWAzse/tuga9GU0Ri5kPYei9smh80iyZRCVN6OB1PyagDnPRHoF2cDdCxut/bbsc8W3mdsVHlgPHOpMVeh2eDBdYnTDGGda322dJG78p88zwFeV91FZ8hWlWM3IjQB2Tqf+0664MjRcHXMOO/ysHAxOXh9y2HlIrebDiKTIGwKmeL0n1MxYHzPr0giGkfHkYf1fwAKw== jan.henning@thorsen.pm"
      ];
    };
  };
}
