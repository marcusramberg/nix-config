_:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/keyboardmap.nix
    ../../modules/desktop.nix
    ../../modules/laptop.nix
    ../../modules/pipewire.nix
  ];
  networking.hostName = "mtop";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  services.flatpak.enable = true;
  services.mbpfan.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.input-remapper.enable = true;
  services.xserver.dpi = 144;

}
