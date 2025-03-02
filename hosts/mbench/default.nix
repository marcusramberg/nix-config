_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  hardware.keyboard.dual-caps.enable = true;
  profiles.dockerHost.enable = true;
  networking = {
    hostName = "mbench";
    networkmanager.enable = true;
  };

  profiles.desktop.enable = true;

  services = {
    mbpfan.enable = true;
    input-remapper.enable = true;
  };
}
