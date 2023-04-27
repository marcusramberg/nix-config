_:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop.nix
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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-802cab2c-7149-467d-bda3-043e42e60dcb".keyFile =
    "/crypto_keyfile.bin";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.  
}
