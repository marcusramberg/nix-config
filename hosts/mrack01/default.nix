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
    hostId = "8fbe374d";
    useNetworkd = true;
  };
  systemd.network = {
    enable = true;
    networks = {
      public = {
        enable = true;
        matchConfig.Name = "eno0";
        networkConfig.ConfigureWithoutCarrier = "yes";
        address = [
          "185.35.202.218/26"
          "2a02:ed06::218/64"
        ];
        routes = [
          { Gateway = "185.35.202.193"; }
          { Gateway = "20a2:ed06::1"; }

        ];
      };
      private = {
        matchConfig.Name = "eno1";
        DHCP = "yes";
      };
    };
  };
  profiles = {
    dockerHost.enable = true;
  };
  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;
}
