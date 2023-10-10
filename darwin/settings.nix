_: {

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
        wvous-br-corner = 13;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = false;
        "com.apple.swipescrolldirection" =
          true; # enable natural scrolling(default to true)
        "com.apple.sound.beep.feedback" =
          0; # disable beep sound when pressing volume up/down key
        AppleInterfaceStyle = "Dark"; # dark mode
      };
      screencapture = {
        type = "jpg";
        disable-shadow = true;
      };
      # Trackpad
      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
      };
      CustomUserPreferences = {
        NSGlobalDomain = {
          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Pictures";
          type = "png";
        };
        "com.apple.AdLib" = { allowApplePersonalizedAdvertising = false; };
        "com.apple.print.PrintingPrefs" = {
          # Automatically quit printer app once the print jobs complete
          "Quit When Finished" = true;
        };
        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;
      };
      loginwindow = {
        GuestEnabled = false; # disable guest user
        SHOWFULLNAME = true; # show full name in login window
      };
    };
    # Keyboard
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    # Instant activation.
    activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
