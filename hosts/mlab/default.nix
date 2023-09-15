_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/keyboardmap.nix
    ../../modules/desktop.nix
    ../../modules/pipewire.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  networking = {
    hostName = "mlab";
    networkmanager.enable = true;
  };

  programs.nm-applet.enable = true;

  services = {
    flatpak.enable = true;
    mbpfan.enable = true;
    input-remapper.enable = true;
  };
  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
  };
}
