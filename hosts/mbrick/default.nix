{ config, lib, user, ... }:

{
  imports = [
    ./mobile-nixos-branding.nix
    ./plasma-mobile.nix
    ../../modules/agenix.nix
    ../../modules/pipewire.nix
  ];

  config = {
    # Forcibly set a password on users...
    # Note that a numeric password is currently required to unlock a session
    # with the plasma mobile shell :/
    users.users.${user}.hashedPasswordFile = config.age.secrets.phone-pin.path;

    # Automatically login as defaultUserName.
    services.xserver.displayManager.autoLogin = { inherit user; };

    # Networking, modem and misc.
    # Ensures any rndis config from stage-1 is not clobbered by NetworkManager
    networking.networkmanager.unmanaged = [ "rndis0" "usb0" ];
    networking.hostName = "mbrick";

    # Setup USB gadget networking in initrd...

    mobile.boot.stage-1.networking.enable = lib.mkDefault true;
    # SSH
    services.openssh.enable = true;

  };
}
