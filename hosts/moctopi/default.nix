{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/pipewire.nix
  ];
  networking.hostName = "butterbee"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = false;
  services.pipewire.audio.enable = true;

  services.flatpak.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  networking.extraHosts = ''
    10.211.55.2 mbook
    0.0.0.0 vg.no www.vg.no
  '';
}
>>>>>>> Stashed changes
