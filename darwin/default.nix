{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  imports = [
    ../modules/agenix.nix
    ../modules/nix.nix
    ../modules/fonts.nix
    ./builder.nix
    ./casks.nix
    ./emacs.nix
  ];

  age.identityPaths = [ "/Users/marcus/.ssh/id_ed25519" ];

  #FIXME: nix-darwin sets this to /var/empty for Reasons[tm]
  # https://github.com/nix-community/home-manager/issues/4026
  users.users.marcus.home = lib.mkForce "/Users/marcus";

  # Need some shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.tailscale.enable = true;

  nix.settings.auto-optimise-store = false;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment = {
    systemPackages = with pkgs; [
      colima
      docker
      gnupg
      gnugrep
      gitFull
      terminal-notifier
    ];
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  # services.karabiner-elements.enable = true;

  # Fonts
  profiles.myfonts.enable = true;

  nix = {
    # extraOptions = "" + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    #   extra-platforms = x86_64-darwin aarch64-darwin
    # '';
    configureBuildUsers = true;
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
  };
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  time.timeZone = "Europe/Oslo";

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };
}
