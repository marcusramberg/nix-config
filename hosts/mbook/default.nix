# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    kernelParams = [
      "apple_dcp.show_notch=1"
    ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };
  environment.systemPackages = with pkgs; [
    ungoogled-chromium
    spotify-player
  ];
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    keyboard.dual-caps.enable = true;
    asahi = {
      enable = true;
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      withRust = true;
    };
  };
  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [ ];
    wifi.backend = "iwd";
  };
  profiles = {
    autoupgrade.enable = true;
    dockerHost.enable = true;
    desktop.enable = true;
  };
  programs = {
    appimage.enable = true;

  };
  security.apparmor.enable = true;
  services = {
    cloudflare-warp.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
