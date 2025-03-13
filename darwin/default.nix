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
  services.tailscale.enable = true;

  nix.settings.auto-optimise-store = false;

  environment = {
    systemPackages = with pkgs; [
      colima
      docker
      gnupg
      gnugrep
      gitFull
      iconv
      terminal-notifier
    ];
    extraSetup = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  # Fonts
  profiles.myfonts.enable = true;

  nix = {
    # extraOptions = "" + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    #   extra-platforms = x86_64-darwin aarch64-darwin
    # '';
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
  };
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  time.timeZone = "Europe/Oslo";

  system.stateVersion = 4;
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };
  ids.gids.nixbld = 30000;
}
