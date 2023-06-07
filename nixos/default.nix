# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  imports = [ ../modules/agenix.nix ../modules/nix.nix ../modules/emacs.nix ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      cached-nix-shell
      gitAndTools.gh
      gcc
      file
      inputs.agenix.packages."${pkgs.system}".default
      lemonade
      man-pages
      mosh
      netavark
      nordic
      ntfs3g
      p7zip
      perl534Packages.EV
      perl534Packages.Mojolicious
      unrar
      wireguard-tools
      wget
      xarchiver
    ];
    variables = {
      # TERM = "xterm-256color";
    };
  };

  age.identityPaths = [ "/home/marcus/.ssh/id_ed25519" ];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.firewall.enable = false;
  services = {
    #printing.enable = true;
    fwupd.enable = true;
    tailscale.enable = true;
    keybase.enable = true;
  };

  # Enable touchpad support.

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    mtr.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
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
  i18n.defaultLocale = "en_DK.UTF-8";

  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages =
      [ "nodejs-16.20.0" "xrdp-0.9.9" "electron-21.4.0" "nodejs-14.21.3" ];
  };
  security.pam.loginLimits = [{
    domain = "marcus";
    type = "soft";
    item = "nofile";
    value = "200000";
  }];

  security.pki.certificateFiles =
    if builtins.pathExists "/home/marcus/.local/share/mkcert/rootCA.pem" then
      [ /home/marcus/.local/share/mkcert/rootCA.pem ]
    else
      [ ];
}
