_:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/keyboardmap.nix
    ../../modules/pipewire.nix
  ];
  networking.hostName = "mbox";
  virtualisation.vmware.guest.enable = true;

  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  #  system.stateVersion = "22.11";
  services.flatpak.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  networking.extraHosts = ''
    10.211.55.2 mbook
    0.0.0.0 vg.no www.vg.no
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  # Enable networking
  networking.networkmanager.enable = true;

}
