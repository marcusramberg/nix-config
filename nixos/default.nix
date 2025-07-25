# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../modules/agenix.nix
    ../modules/autoupgrade.nix
    ../modules/caddy.nix
    ../modules/nix.nix
    ../modules/fonts.nix
    ./amd.nix
    ./ddcutil.nix
    ./desktop.nix
    ./docker.nix
    ./emacs.nix
    ./hass.nix
    ./gaming.nix
    # ./grafana-kiosk.nix
    ./hyprland.nix
    ./k3s.nix
    ./kodi.nix
    ./keyboardmap.nix
    ./laptop.nix
    ./mediaserver.nix
    ./nimdow.nix
    ./nvidia.nix
    ./pg_upgrade.nix
    ./passthrough.nix
    ./prometheus.nix
  ];

  boot.loader.systemd-boot.configurationLimit = 5;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    etc.hosts.mode = "0644";
    systemPackages = with pkgs; [
      cached-nix-shell
      caddy
      file
      gcc
      inputs.ghostty.packages.${pkgs.system}.default.terminfo
      gitFull
      inputs.agenix.packages.${pkgs.system}.default
      mosh
      netavark
      ntfs3g
      p7zip
      pciutils
      perlPackages.EV
      perlPackages.Mojolicious
      unrar
      usbutils
      wget
      wireguard-tools
    ];
    variables = {
      # TERM = "xterm-256color";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  age.identityPaths = [ "/home/marcus/.ssh/id_ed25519" ];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.firewall.enable = false;

  services = {
    fwupd.enable = true;
    tailscale.enable = true;
    keybase.enable = true;
    timesyncd.enable = lib.mkDefault true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld = {
      enable = true;
      libraries = [
        pkgs.pciutils
      ];
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
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "dialout"
      "feedbackd"
      "incus-admin"
      "pipewire"
      "podman"
      "video"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz marcus@butterbee"
    ];
    uid = 1000;
    shell = pkgs.fish;
    initialHashedPassword = "$y$j9T$macjSemIfW9l003gAalB5.$1LpRma6WvwC7WwcvkwuwifLrLxcyrOuiKW70/SnC5J0";

  };

  system = {
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    stateVersion = lib.mkDefault "23.05";
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_DK.UTF-8";

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    distributedBuilds = true;
  };

  security = {
    pam.loginLimits = [
      {
        domain = "marcus";
        type = "soft";
        item = "nofile";
        value = "200000";
      }
    ];
    pki.certificateFiles =
      if builtins.pathExists "/home/marcus/.local/share/mkcert/rootCA.pem" then
        [ /home/marcus/.local/share/mkcert/rootCA.pem ]
      else
        [ ];
    sudo.wheelNeedsPassword = false;
  };
  # Always be sshing
  services.openssh.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
    "electron-31.7.7"
  ];
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };

}
