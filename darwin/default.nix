{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];
  nix.configureBuildUsers = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    wezterm
    karabiner-elements
    goku
    terminal-notifier
  ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.defaults.dock = {
    show-recents = false;
    showhidden = true;
    static-only = true;
    orientation = "right";
    mru-spaces = false;
    minimize-to-application = true;
    mineffect = "scale";
    autohide = false;
  };
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv";
    QuitMenuItem = true;
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true;
  };
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.defaults.dock.wvous-br-corner = 13;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults.screencapture = {
    type = "jpg";
    disable-shadow = true;
  };

  # Trackpad
  system.defaults.trackpad = {
    ActuationStrength = 0;
    Clicking = true;
  };


  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  time.timeZone = "Europe/Oslo";

}
