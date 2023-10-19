{ pkgs, osConfig, ... }: {

  appRule = [
    {
      class = "org.wezfurlong.wezterm";
      state = "normal";
    }
    {
      class = "Vivaldi-stable";
      monitor = 1;
      state = "normal";
      tags = [ 2 ];
    }
    {
      class = "firefoxdeveloperedition";
      monitor = 1;
      state = "normal";
      tags = [ 2 ];
    }
    {
      monitor = 1;
      state = "normal";
      tags = [ 3 ];
      title = "telega";
    }
    {
      class = "TelegramDesktop";
      monitor = 1;
      state = "normal";
      tags = [ 4 ];
    }
  ];
  autostart = {
    exec = [
      "~/.config/nimdow/status"
      "xsetroot -cursor_name left_ptr"
      "feh --bg-fill -z /etc/nixos/wallpaper/"
      "wezterm"
      "telegram-desktop"
      "vivaldi"
      "volumeicon"
      "zeal"
    ] ++ pkgs.lib.optional (osConfig.networking.hostName == "mbox")
      "streamdeck -n";
  };
  controls = {
    decreaseMasterCount = {
      keys = [ "x" ];
      modifiers = [ "super" ];
    };
    decreaseMasterWidth = {
      keys = [ "h" ];
      modifiers = [ "super" ];
    };
    destroySelectedWindow = {
      keys = [ "d" ];
      modifiers = [ "super" "shift" ];
    };
    focusNext = {
      keys = [ "j" ];
      modifiers = [ "super" ];
    };
    focusNextMonitor = {
      keys = [ "period" ];
      modifiers = [ "super" ];
    };
    focusPrevious = {
      keys = [ "k" ];
      modifiers = [ "super" ];
    };
    focusPreviousMonitor = {
      keys = [ "comma" ];
      modifiers = [ "super" ];
    };
    goToLeftTag = {
      keys = [ "Left" ];
      modifiers = [ "super" ];
    };
    goToPreviousTag = {
      keys = [ "w" ];
      modifiers = [ "super" ];
    };
    goToRightTag = {
      keys = [ "Right" ];
      modifiers = [ "super" ];
    };
    goToTag = {
      keys = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      modifiers = [ "super" ];
    };
    increaseMasterCount = {
      keys = [ "z" ];
      modifiers = [ "super" ];
    };
    increaseMasterWidth = {
      keys = [ "l" ];
      modifiers = [ "super" ];
    };
    jumpToUrgentWindow = {
      keys = [ "u" ];
      modifiers = [ "super" ];
    };
    moveWindowNext = {
      keys = [ "j" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowPrevious = {
      keys = [ "k" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToLeftTag = {
      keys = [ "Left" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToNextMonitor = {
      keys = [ "period" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToPreviousMonitor = {
      keys = [ "comma" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToPreviousTag = {
      keys = [ "w" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToRightTag = {
      keys = [ "Right" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToScratchpad = {
      keys = [ "s" ];
      modifiers = [ "super" "shift" ];
    };
    moveWindowToTag = {
      keys = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      modifiers = [ "super" "shift" ];
    };
    popScratchpad = {
      keys = [ "s" ];
      modifiers = [ "super" ];
    };
    reloadConfig = {
      keys = [ "r" ];
      modifiers = [ "super" "shift" ];
    };
    rotateClients = {
      keys = [ "r" ];
      modifiers = [ "super" ];
    };
    toggleFloating = {
      keys = [ "space" ];
      modifiers = [ "shift" "super" ];
    };
    toggleFullscreen = {
      keys = [ "f" ];
      modifiers = [ "super" ];
    };
    toggleTagView = {
      keys = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      modifiers = [ "super" "control" ];
    };
    toggleWindowTag = {
      keys = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      modifiers = [ "super" "shift" "control" ];
    };
  };
  monitors = {
    default = {
      tags = {
        "1" = {
          defaultMasterWidthPercentage = 65;
          displayString = "1 ";
        };
        "2" = {
          defaultMasterWidthPercentage = 75;
          displayString = "2 ";
        };
        "3" = { displayString = "3 "; };
        "4" = { displayString = "4 "; };
        "5" = { displayString = "5 "; };
        "6" = { displayString = "6 "; };
        "7" = { displayString = "7 "; };
        "8" = { displayString = "8 "; };
        "9" = { displayString = "9 "; };
      };
    };
  };
  settings = {
    barBackgroundColor = "#434C5E";
    barFonts = [
      "Hack Nerd Font Mono:size=12:antialias=true"
      "NotoColorEmoji:size=11:antialias=true"
    ];
    barHeight = 35;
    barForegroundColor = "#ECEFF4";
    barSelectionColor = "#88c0d0";
    barUrgentColor = "#BF616A";
    borderColorFocused = "#8FBCBB";
    borderColorUnfocused = "#4C566A";
    borderColorUrgent = "#D08770";
    borderWidth = 1;
    defaultMasterWidthPercentage = 60;
    gapSize = 16;
    loggingEnabled = true;
    outerGap = 8;
    resizeStep = 100;
    reverseTagScrolling = false;
    scratchpadHeight = 500;
    scratchpadWidth = 600;
    windowTitlePosition = "center";
  };
  startProcess = [
    {
      command = "sudo pkill X";
      keys = [ "e" ];
      modifiers = [ "super" "shift" ];
    }
    {
      command = "~/Source/nixpkgs/result/bin/vivaldi --force-dark-mode";
      keys = [ "b" ];
      modifiers = [ "super" ];
    }
    {
      command = "rofi -show run";
      keys = [ "space" ];
      modifiers = [ "super" ];
    }
    {
      command = "rofi -show run";
      keys = [ "d" ];
      modifiers = [ "super" ];
    }
    {
      command =
        "maim -s | tee ~/Pictures/$(date +%s).png | xclip -selection clipboard -t image/png";
      keys = [ "p" ];
      modifiers = [ "super" "shift" ];
    }
    {
      command = ''wezterm start bash -c "xprop; sleep 100"'';
      keys = [ "x" ];
      modifiers = [ "super" "shift" ];
    }
    {
      clickRegion = 1;
      command = "pavucontrol";
    }
    {
      command = "wezterm start";
      keys = [ "Return" ];
      modifiers = [ "super" ];
    }
    {
      command = "wezterm";
      keys = [ "Return" ];
      modifiers = [ "super" "shift" ];
    }
    {
      clickRegion = 1;
      command = ''notify-send "Id: %1, rx: %2, cx: %4, w: %6"'';
    }
  ];
}

