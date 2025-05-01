# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  environment.systemPackages = with pkgs; [
    spotify-player
  ];
  hardware = {
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      withRust = true;
    };
  };
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.networkmanager.enable = true;
  profiles = {
    autoupgrade.enable = true;
    dockerHost.enable = true;
    desktop.enable = true;
  };
  programs = {
    appimage.enable = true;

  };
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig.pipewire-pulse."context.exec" = [
        {
          path = "pactl";
          args = "load-module module-switch-on-connect";
        }
      ];
      wireplumber.enable = true;
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
