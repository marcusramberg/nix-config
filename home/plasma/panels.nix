[
  {
    alignment = "center";
    floating = true;
    height = 36;
    location = "top";
    opacity = "translucent";
    screen = "all";
    widgets = [
      {
        kickoff = {
          sortAlphabetically = true;
          icon = "nix-snowflake";
          popupWidth = 500;
          showButtonsFor.custom = [
            "logout"
            "reboot"
            "shutdown"
          ];
        };
      }
      {
        panelSpacer = {
          length = 20;
          expanding = false;
        };
      }
      {
        pager.general = {
          showWindowOutlines = false;
          showOnlyCurrentScreen = true;
          navigationWrapsAround = true;
          displayedText = "desktopName";
        };
      }
      {
        panelSpacer = {
          length = 30;
          expanding = false;
        };
      }
      {
        iconTasks = {
          appearance = {
            showTooltips = false;
            highlightWindows = false;
            indicateAudioStreams = true;
            fill = true;
          };
          behavior = {
            grouping.method = "none";
            sortingMethod = "byHorizontalPosition";
            middleClickAction = "close";
            showTasks.onlyInCurrentDesktop = true;
          };
          launchers = [ ];
        };
      }
      {
        systemTray.items = {
          shown = [
            "org.kde.plasma.volume"
            "org.kde.plasma.brightness"
            "org.kde.plasma.battery"
            "org.kde.plasma.networkmanagement"
            "org.kde.plasma.bluetooth"
          ];
          hidden = [
            "org.kde.plasma.clipboard"
          ];
        };
      }
      {
        digitalClock = {
          date = {
            format = "isoDate";
            position = "belowTime";
          };
          time = {
            showSeconds = "onlyInTooltip";
            format = "24h";
          };
          timeZone = {
            selected = [
              "Europe/Oslo"
              "Asia/Tokyo"
            ];
            lastSelected = "Local";
            changeOnScroll = true;
          };
        };
      }
    ];
  }
]
