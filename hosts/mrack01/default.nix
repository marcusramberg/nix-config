{ config, ... }:
{
  imports = [
    ./disko.nix
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
    firewall.trustedInterfaces = [ "incusbr0" ];
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
  profiles = {
    caddy = {
      enable = true;
      configFile = ../../config/Caddyfile.mrack01;
    };
    dockerHost.enable = true;
  };
  users.users = {
    arne = {
      description = "Arne";
      isNormalUser = true;
      uid = 1002;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+U+XWGwbEvVPgyqDLmHNvvFivn0GLN7fYizfDlYPWw arne@fismen.net"
      ];
    };
  };
  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
