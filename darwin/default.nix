{ pkgs, lib, ... }: {
  # Nix configuration ------------------------------------------------------------------------------

  imports = [ ../modules/agenix.nix ../modules/nix.nix ./casks.nix ];

  age.identityPaths = [ "/Users/marcus/.ssh/id_ed25519" ];

  #FIXME: nix-darwin sets this to /var/empty for Reasons[tm]
  users.users.marcus.home = "/Users/marcus";

  # Need some shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment = {
    systemPackages = with pkgs; [
      colima
      gnupg
      goku
      gitFull
      element-desktop
      terminal-notifier
    ];
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  # services.karabiner-elements.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
  ];

  system = {

    defaults = {
      dock = {
        show-recents = false;
        showhidden = true;
        static-only = true;
        orientation = "right";
        mru-spaces = false;
        minimize-to-application = true;
        mineffect = "scale";
        autohide = true;
      };
      dock.wvous-br-corner = 13;
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      NSGlobalDomain._HIHideMenuBar = false;
      screencapture = {
        type = "jpg";
        disable-shadow = true;
      };
      # Trackpad
      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
      };
    };
    # Keyboard
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    configureBuildUsers = true;
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
  };
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  time.timeZone = "Europe/Oslo";

}
