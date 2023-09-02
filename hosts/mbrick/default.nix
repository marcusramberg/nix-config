# System configuration for the demo.
#
{ config, inputs, lib, user, pkgs, ... }:

let
  # One-stop shop to customize the default username before building.
  defaultUserName = "marcus";
in {
  imports = [
    ./mobile-nixos-branding.nix
    ./plasma-mobile.nix
    ../../modules/agenix.nix
  ];

  config = lib.mkMerge [
    {
  environment = {
    systemPackages = with pkgs; [
      cached-nix-shell
      gitFull
      gitAndTools.gh
      inputs.agenix.packages."${pkgs.system}".default
    ];
  };
      age.identityPaths = [ "/home/marcus/.ssh/id_ed25519" ];
      programs.fish.enable = true;
      programs.neovim = {
        enable = true;
        viAlias = true;
        defaultEditor = true;
      };
      nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];
      # Forcibly set a password on users...
      # Note that a numeric password is currently required to unlock a session
      # with the plasma mobile shell :/
      users.users.${user} = {
        isNormalUser = true;
        # Numeric pin makes it **possible** to input on the lockscreen.
        shell = pkgs.fish;
        passwordFile = config.age.secrets.phone-pin.path;
        home = "/home/${defaultUserName}";
        extraGroups =
          [ "dialout" "feedbackd" "networkmanager" "video" "wheel" ];
        uid = 1000;
      };

      # Automatically login as defaultUserName.
      services.xserver.displayManager.autoLogin = { user = defaultUserName; };
    }

    # Networking, modem and misc.
    {
      # Ensures any rndis config from stage-1 is not clobbered by NetworkManager
      networking.networkmanager.unmanaged = [ "rndis0" "usb0" ];
      networking.hostName = "mbrick";
      services.tailscale.enable = true;

      # Setup USB gadget networking in initrd...
      mobile.boot.stage-1.networking.enable = lib.mkDefault true;
    }

    # SSH
    { services.openssh.enable = true; }
  ];
}
