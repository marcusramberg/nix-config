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
    ./keyboardmap.nix
    ./laptop.nix
    ./lemmy.nix
    ./mediaserver.nix
    ./nimdow.nix
    ./nvidia.nix
    ./passthrough.nix
    ./prometheus.nix
  ];

  boot.loader.systemd-boot.configurationLimit = 5;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      cached-nix-shell
      caddy
      gitFull
      gcc
      file
      inputs.agenix.packages."${pkgs.system}".default
      mosh
      netavark
      ntfs3g
      p7zip
      pciutils
      perlPackages.Mojolicious
      perlPackages.EV
      usbutils
      unrar
      wireguard-tools
      wget
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
      "podman"
      "video"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-dss AAAAB3NzaC1kc3MAAACBAPVoieT49q33TM8oXgWXUaRTZMt5n4uCp4rfiqE7uTHtGe4lxSbjbo5BoG56n8c3vkcLGWZngO5H3YWkZ3vmSIUysjMCSOcH3aqxLIrfo/wEfnhd18jMn4CMZK6I53yY06o2h9jW2B4RsKxaVsOP7+9vhbLhIt+WFhW3/HGgMl6DAAAAFQCOqlaHgMHRaJXsLfT8Zro6BRz+VwAAAIEA4tWRdLMjzxXyJpVSoAsxvY42y+CYjCQScBWiEe6XsEmvbsV+kOrSgjZWNg54cUnHVFaIZ9RtK2kwEVKTlVUTweGIps5NIq5yqHwvqSO4yDoxvfVeq0l3dSAoCLrOFQNAMs54rJakM8xQ8KSS6iKiM+cU0GjhwvFUpou14UA4udQAAACBAKnHRR6f6eXxmx8RWGLsYMdFMgEFDSjZp4zbdM763efU3p7R3xh1arYVXFPzQBBIB1O5WvKk7Qlpq0adSMVyM55vw5vAwrcJpOy8dYdrGqUnkEQPTddzcB1Mm4/4xn/Oe6Oiqa9bT9S3s0wvM/s01+kDXEEo1gfw05H8FDKPo7uD marcus@means.no"
    ];
    uid = 1000;
    shell = pkgs.fish;
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
  ];
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };

}
