# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
      cached-nix-shell
      gitAndTools.gh
      gcc
      man-pages
      mosh
      nerdfonts
      ntfs3g
      p7zip
      perl534Packages.EV
      perl534Packages.Mojolicious
      unrar
      wget
      wireguard-tools
      xarchiver
    ];
    variables = {
      # TERM = "xterm-256color";
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];


  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "marcus" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";

    };
  };


  networking.firewall.enable = false;
  services = {
    #printing.enable = true;
    fwupd.enable = true;
  };
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support.

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  programs = {
    dconf.enable = true;
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    mtr.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      defaultEditor = true;
    };
  };

  users.users.marcus = {
    isNormalUser = true;
    description = "Marcus Ramberg";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    uid = 1000;
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;

  system = {
    autoUpgrade.enable = true;
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    stateVersion = "22.05";
  };
  time.timeZone = "Europe/Oslo";

  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages = [
      "xrdp-0.9.9"
    ];
  };
  security.pam.loginLimits = [{
    domain = "marcus";
    type = "soft";
    item = "nofile";
    value = "200000";
  }];

}
