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
  networking.hostId = "8fbe374d";
  systemd = {
    network.enable = true;
  };
  profiles = {
    dockerHost.enable = true;
  };
  networking = {
    networkmanager.enable = true;
  };
}
