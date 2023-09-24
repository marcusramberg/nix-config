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
    hostName = "mlab";
    networkmanager.enable = true;
  };

  profiles.nimdow.enable = true;
  programs.nm-applet.enable = true;

  services = {
    flatpak.enable = true;
    mbpfan.enable = true;
    input-remapper.enable = true;
  };
}
