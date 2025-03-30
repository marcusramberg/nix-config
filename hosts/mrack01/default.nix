_: {
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
  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
