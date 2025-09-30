{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./disko.nix
    ./forgejo.nix
  ];
  age.secrets.woodpecker-ci.owner = "woodpecker-server";
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
      trustedInterfaces = [
        "incusbr0"
      ];
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
  };
  services = {
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
      settings = {
        APP_URL = "https://auth.means.no";
        TRUST_PROXY = true;
      };
    };
    openssh.settings.PasswordAuthentication = false;
    tailscale.useRoutingFeatures = "server";
    woodpecker-server = {
      enable = true;
      environment = {
        WOODPECKER_HOST = "https://ci.bas.es";
        WOODPECKER_OPEN = "true";
        WOODPECKER_ORGS = "bas.es";
        WOODPECKER_ADMIN = "marcus";
        WOODPECKER_FORGEJO = "true";
        WOODPECKER_FORGEJO_URL = "https://git.bas.es";
        WOODPECKER_FORGEJO_CLIENT = "a2bb5dd4-85db-4d83-a7bc-12166b7aa5b7";
      };
      environmentFile = config.age.secrets.woodpecker-ci.path;
    };

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
          { Gateway = "20a2:ed06::1"; }

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
  };
  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
