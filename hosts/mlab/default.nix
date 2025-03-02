{ config, ... }:
{
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
  hardware.enableRedistributableFirmware = true;

  networking.wireless = {
    secretsFile = config.age.secrets.wireless.path;
    networks."means.no".pskRaw = "ext:meanspsk";
  };
  profiles.nimdow.enable = true;
  programs.nm-applet.enable = true;

  services = {
    mbpfan.enable = true;
    input-remapper.enable = true;
    displayManager.autoLogin = {
      enable = true;
      user = "marcus";
    };
  };
}
