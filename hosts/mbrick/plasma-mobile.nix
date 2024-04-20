# Minimum config used to enable Plasma Mobile.
#
{ lib, pkgs, ... }:

{
  mobile.beautification = {
    silentBoot = lib.mkDefault true;
    splash = lib.mkDefault true;
  };

  services.displayManager = {
    defaultSession = "plasma-mobile";
    lightdm = {
      enable = true;
      # Workaround for autologin only working at first launch.
      # A logout or session crashing will show the login screen otherwise.
      extraSeatDefaults = ''
        session-cleanup-script=${pkgs.procps}/bin/pkill -P1 -fx ${pkgs.lightdm}/sbin/lightdm
      '';
    };
    autoLogin.enable = true;
  };
  services.xserver = {
    enable = true;

    desktopManager.plasma5.mobile.enable = true;

    libinput.enable = true;
  };

  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  powerManagement.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
}
