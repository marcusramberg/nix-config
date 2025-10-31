{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = pkgs.stdenv.isLinux && (isNixOS && osConfig.services.xserver.enable);
in
{
  config = lib.mkIf isDesktop {
    programs.plasma = {
      enable = true;
      shortcuts = {
        "KDE Keyboard Layout Switcher" = {
          "Switch to Last-Used Keyboard Layout" = "none,Meta+Alt+L,Switch to Last-Used Keyboard Layout";
          "Switch to Next Keyboard Layout" = "none,Meta+Alt+K,Switch to Next Keyboard Layout";
        };
        "com.github.hluk.copyq" = {
          "LOGO+ALT+V||Show/hide main window" = "Meta+Alt+V";
          "LOGO+SHIFT+V||Paste clipboard as plain text" = "Meta+Shift+V";
        };
        kaccess."Toggle Screen Reader On and Off" = "none,Meta+Alt+S,Toggle Screen Reader On and Off";
        kmix = {
          "decrease_microphone_volume" = "Microphone Volume Down";
          "decrease_volume" = "Volume Down";
          "decrease_volume_small" = "Shift+Volume Down";
          "increase_microphone_volume" = "Microphone Volume Up";
          "increase_volume" = "Volume Up";
          "increase_volume_small" = "Shift+Volume Up";
          "mic_mute" = [
            "Microphone Mute"
            "Meta+Volume Mute,Microphone Mute"
            "Meta+Volume Mute,Mute Microphone"
          ];
          "mute" = "Volume Mute";
        };
        ksmserver = {
          "Halt Without Confirmation" = "none,,Shut Down Without Confirmation";
          "Lock Session" = [
            "Screensaver,Meta+L"
            "Screensaver,Lock Session"
          ];
          "Log Out" = "Meta+Shift+E,Ctrl+Alt+Del,Show Logout Screen";
          "Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
          "LogOut" = "none,,Log Out";
          "Reboot" = "none,,Reboot";
          "Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
          "Shut Down" = "none,,Shut Down";
        };
        kwin = {
          "Activate Window Demanding Attention" = "none,Meta+Ctrl+A,Activate Window Demanding Attention";
          "Cycle Overview" = [ ];
          "Cycle Overview Opposite" = [ ];
          "Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
          "Edit Tiles" = "none,Meta+T,Toggle Tiles Editor";
          "Expose" = "none,Ctrl+F9,Toggle Present Windows (Current desktop)";
          "ExposeAll" = [
            "none,Ctrl+F10"
            "Launch (C),Toggle Present Windows (All desktops)"
          ];
          "ExposeClass" = "none,Ctrl+F7,Toggle Present Windows (Window class)";
          "ExposeClassCurrentDesktop" = [ ];
          "Grid View" = "none,Meta+G,Toggle Grid View";
          "Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
          "Kill Window" = "none,Meta+Ctrl+Esc,Kill Window";
          "Move Tablet to Next Output" = [ ];
          "MoveMouseToCenter" = "none,Meta+F6,Move Mouse to Center";
          "MoveMouseToFocus" = "none,Meta+F5,Move Mouse to Focus";
          "MoveZoomDown" = [ ];
          "MoveZoomLeft" = [ ];
          "MoveZoomRight" = [ ];
          "MoveZoomUp" = [ ];
          "Overview" = "none,Meta+W,Toggle Overview";
          "Setup Window Shortcut" = "none,,Setup Window Shortcut";
          "Show Desktop" = "Meta+D";
          "Switch One Desktop Down" = "none,Meta+Ctrl+Down,Switch One Desktop Down";
          "Switch One Desktop Up" = "none,Meta+Ctrl+Up,Switch One Desktop Up";
          "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
          "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
          "Switch Window Down" = "Meta+Alt+Down";
          "Switch Window Left" = "Meta+Alt+Left";
          "Switch Window Right" = "Meta+Alt+Right";
          "Switch Window Up" = "Meta+Alt+Up";
          "Switch to Desktop 1" = "Meta+1,Ctrl+F1,Switch to Desktop 1";
          "Switch to Desktop 10" = "Meta+0,,Switch to Desktop 10";
          "Switch to Desktop 11" = "none,,Switch to Desktop 11";
          "Switch to Desktop 12" = "none,,Switch to Desktop 12";
          "Switch to Desktop 13" = "none,,Switch to Desktop 13";
          "Switch to Desktop 14" = "none,,Switch to Desktop 14";
          "Switch to Desktop 15" = "none,,Switch to Desktop 15";
          "Switch to Desktop 16" = "none,,Switch to Desktop 16";
          "Switch to Desktop 17" = "none,,Switch to Desktop 17";
          "Switch to Desktop 18" = "none,,Switch to Desktop 18";
          "Switch to Desktop 19" = "none,,Switch to Desktop 19";
          "Switch to Desktop 2" = "Meta+2,Ctrl+F2,Switch to Desktop 2";
          "Switch to Desktop 20" = "none,,Switch to Desktop 20";
          "Switch to Desktop 3" = "Meta+3,Ctrl+F3,Switch to Desktop 3";
          "Switch to Desktop 4" = "Meta+4,Ctrl+F4,Switch to Desktop 4";
          "Switch to Desktop 5" = "Meta+5,,Switch to Desktop 5";
          "Switch to Desktop 6" = "Meta+6,,Switch to Desktop 6";
          "Switch to Desktop 7" = "Meta+7,,Switch to Desktop 7";
          "Switch to Desktop 8" = "Meta+8,,Switch to Desktop 8";
          "Switch to Desktop 9" = "Meta+9,,Switch to Desktop 9";
          "Switch to Next Desktop" = "none,,Switch to Next Desktop";
          "Switch to Next Screen" = "none,,Switch to Next Screen";
          "Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
          "Switch to Previous Screen" = "none,,Switch to Previous Screen";
          "Switch to Screen 0" = "none,,Switch to Screen 0";
          "Switch to Screen 1" = "none,,Switch to Screen 1";
          "Switch to Screen 2" = "none,,Switch to Screen 2";
          "Switch to Screen 3" = "none,,Switch to Screen 3";
          "Switch to Screen 4" = "none,,Switch to Screen 4";
          "Switch to Screen 5" = "none,,Switch to Screen 5";
          "Switch to Screen 6" = "none,,Switch to Screen 6";
          "Switch to Screen 7" = "none,,Switch to Screen 7";
          "Switch to Screen Above" = "none,,Switch to Screen Above";
          "Switch to Screen Below" = "none,,Switch to Screen Below";
          "Switch to Screen to the Left" = "Meta+Y,,Switch to Screen to the Left";
          "Switch to Screen to the Right" = "Meta+Shift+Y,,Switch to Screen to the Right";
          "Toggle Night Color" = [ ];
          "Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
          "Walk Through Windows" = [
            "Meta+Tab,Meta+Tab"
            "Alt+Tab,Walk Through Windows"
          ];
          "Walk Through Windows (Reverse)" = [
            "Meta+Shift+Tab,Meta+Shift+Tab"
            "Alt+Shift+Tab,Walk Through Windows (Reverse)"
          ];
          "Walk Through Windows Alternative" = "Alt+Tab,none,Walk Through Windows Alternative";
          "Walk Through Windows Alternative (Reverse)" =
            "Alt+Shift+Tab,none,Walk Through Windows Alternative (Reverse)";
          "Walk Through Windows of Current Application" = [
            "Meta+Ctrl+Tab,Meta+`"
            "Alt+`,Walk Through Windows of Current Application"
          ];
          "Walk Through Windows of Current Application (Reverse)" = [
            "Meta+Ctrl+Shift+Tab,Meta+~"
            "Alt+~,Walk Through Windows of Current Application (Reverse)"
          ];
          "Walk Through Windows of Current Application Alternative" = [ ];
          "Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
          "Window Above Other Windows" = "none,,Keep Window Above Others";
          "Window Below Other Windows" = "none,,Keep Window Below Others";
          "Window Close" = "Meta+Shift+Q,Alt+F4,Close Window";
          "Window Custom Quick Tile Bottom" = "none,,Custom Quick Tile Window to the Bottom";
          "Window Custom Quick Tile Left" = "none,,Custom Quick Tile Window to the Left";
          "Window Custom Quick Tile Right" = "none,,Custom Quick Tile Window to the Right";
          "Window Custom Quick Tile Top" = "none,,Custom Quick Tile Window to the Top";
          "Window Fullscreen" = "none,,Make Window Fullscreen";
          "Window Grow Horizontal" = "none,,Expand Window Horizontally";
          "Window Grow Vertical" = "none,,Expand Window Vertically";
          "Window Lower" = "none,,Lower Window";
          "Window Maximize" = "Meta+M,Meta+PgUp,Maximize Window";
          "Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
          "Window Maximize Vertical" = "none,,Maximize Window Vertically";
          "Window Minimize" = "none,Meta+PgDown,Minimize Window";
          "Window Move" = "none,,Move Window";
          "Window Move Center" = "none,,Move Window to the Center";
          "Window No Border" = "none,,Toggle Window Titlebar and Frame";
          "Window On All Desktops" = "none,,Keep Window on All Desktops";
          "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
          "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
          "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
          "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
          "Window One Screen Down" = "none,,Move Window One Screen Down";
          "Window One Screen Up" = "none,,Move Window One Screen Up";
          "Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
          "Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
          "Window Operations Menu" = "Ctrl+Space,Alt+F3,Window Menu";
          "Window Pack Down" = "none,,Move Window Down";
          "Window Pack Left" = "none,,Move Window Left";
          "Window Pack Right" = "none,,Move Window Right";
          "Window Pack Up" = "none,,Move Window Up";
          "Window Quick Tile Bottom" = "none,Meta+Down,Quick Tile Window to the Bottom";
          "Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
          "Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
          "Window Quick Tile Left" = "none,Meta+Left,Quick Tile Window to the Left";
          "Window Quick Tile Right" = "none,Meta+Right,Quick Tile Window to the Right";
          "Window Quick Tile Top" = "none,Meta+Up,Quick Tile Window to the Top";
          "Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
          "Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
          "Window Raise" = "none,,Raise Window";
          "Window Resize" = "none,,Resize Window";
          "Window Shade" = [ ];
          "Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
          "Window Shrink Vertical" = "none,,Shrink Window Vertically";
          "Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
          "Window to Desktop 10" = "Meta+),,Window to Desktop 10";
          "Window to Desktop 11" = "none,,Window to Desktop 11";
          "Window to Desktop 12" = "none,,Window to Desktop 12";
          "Window to Desktop 13" = "none,,Window to Desktop 13";
          "Window to Desktop 14" = "none,,Window to Desktop 14";
          "Window to Desktop 15" = "none,,Window to Desktop 15";
          "Window to Desktop 16" = "none,,Window to Desktop 16";
          "Window to Desktop 17" = "none,,Window to Desktop 17";
          "Window to Desktop 18" = "none,,Window to Desktop 18";
          "Window to Desktop 19" = "none,,Window to Desktop 19";
          "Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
          "Window to Desktop 20" = "none,,Window to Desktop 20";
          "Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
          "Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
          "Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
          "Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
          "Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
          "Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
          "Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
          "Window to Next Desktop" = "none,,Window to Next Desktop";
          "Window to Next Screen" = "Meta+Shift+Right";
          "Window to Previous Desktop" = "none,,Window to Previous Desktop";
          "Window to Previous Screen" = "Meta+Shift+Left";
          "Window to Screen 0" = "Meta+Ctrl+1,,Move Window to Screen 0";
          "Window to Screen 1" = "Meta+Ctrl+2,,Move Window to Screen 1";
          "Window to Screen 2" = "none,,Move Window to Screen 2";
          "Window to Screen 3" = "none,,Move Window to Screen 3";
          "Window to Screen 4" = "none,,Move Window to Screen 4";
          "Window to Screen 5" = "none,,Move Window to Screen 5";
          "Window to Screen 6" = "none,,Move Window to Screen 6";
          "Window to Screen 7" = "none,,Move Window to Screen 7";
          "disableInputCapture" = "Meta+Shift+Esc";
          "karousel-column-move-end" = "Meta+Ctrl+Shift+End,none,Karousel: Move column to end";
          "karousel-column-move-left" = "Meta+Shift+O,none,Karousel: Move column left";
          "karousel-column-move-right" = [ ];
          "karousel-column-move-start" = [ ];
          "karousel-column-move-to-column-1" = "Meta+Ctrl+Shift+1,none,Karousel: Move column to position 1";
          "karousel-column-move-to-column-10" = [ ];
          "karousel-column-move-to-column-11" = [ ];
          "karousel-column-move-to-column-12" = [ ];
          "karousel-column-move-to-column-2" = "Meta+Ctrl+Shift+2,none,Karousel: Move column to position 2";
          "karousel-column-move-to-column-3" = "Meta+Ctrl+Shift+3,none,Karousel: Move column to position 3";
          "karousel-column-move-to-column-4" = "Meta+Ctrl+Shift+4,none,Karousel: Move column to position 4";
          "karousel-column-move-to-column-5" = "Meta+Ctrl+Shift+5,none,Karousel: Move column to position 5";
          "karousel-column-move-to-column-6" = "Meta+Ctrl+Shift+6,none,Karousel: Move column to position 6";
          "karousel-column-move-to-column-7" = "Meta+Ctrl+Shift+7,none,Karousel: Move column to position 7";
          "karousel-column-move-to-column-8" = "Meta+Ctrl+Shift+8,none,Karousel: Move column to position 8";
          "karousel-column-move-to-column-9" = "Meta+Ctrl+Shift+9,none,Karousel: Move column to position 9";
          "karousel-column-move-to-desktop-1" = "Meta+Ctrl+Shift+F1,none,Karousel: Move column to desktop 1";
          "karousel-column-move-to-desktop-10" =
            "Meta+Ctrl+Shift+F10,none,Karousel: Move column to desktop 10";
          "karousel-column-move-to-desktop-11" =
            "Meta+Ctrl+Shift+F11,none,Karousel: Move column to desktop 11";
          "karousel-column-move-to-desktop-12" =
            "Meta+Ctrl+Shift+F12,none,Karousel: Move column to desktop 12";
          "karousel-column-move-to-desktop-2" = "Meta+Ctrl+Shift+F2,none,Karousel: Move column to desktop 2";
          "karousel-column-move-to-desktop-3" = "Meta+Ctrl+Shift+F3,none,Karousel: Move column to desktop 3";
          "karousel-column-move-to-desktop-4" = "Meta+Ctrl+Shift+F4,none,Karousel: Move column to desktop 4";
          "karousel-column-move-to-desktop-5" = "Meta+Ctrl+Shift+F5,none,Karousel: Move column to desktop 5";
          "karousel-column-move-to-desktop-6" = "Meta+Ctrl+Shift+F6,none,Karousel: Move column to desktop 6";
          "karousel-column-move-to-desktop-7" = "Meta+Ctrl+Shift+F7,none,Karousel: Move column to desktop 7";
          "karousel-column-move-to-desktop-8" = "Meta+Ctrl+Shift+F8,none,Karousel: Move column to desktop 8";
          "karousel-column-move-to-desktop-9" = "Meta+Ctrl+Shift+F9,none,Karousel: Move column to desktop 9";
          "karousel-column-toggle-stacked" =
            "Meta+Shift+X,none,Karousel: Toggle stacked layout for focused column";
          "karousel-column-width-decrease" = "Meta+Ctrl+H,none,Karousel: Decrease column width";
          "karousel-column-width-increase" = "Meta+Ctrl+L,none,Karousel: Increase column width";
          "karousel-columns-squeeze-left" = [ ];
          "karousel-columns-squeeze-right" =
            "Meta+Ctrl+D,none,Karousel: Squeeze right column onto the screen";
          "karousel-columns-width-equalize" = "Meta+B,none,Karousel: Equalize widths of visible columns";
          "karousel-cycle-preset-widths" = "Meta+R,none,Karousel: Cycle through preset column widths";
          "karousel-cycle-preset-widths-reverse" = [ ];
          "karousel-focus-1" = [ ];
          "karousel-focus-10" = [ ];
          "karousel-focus-11" = [ ];
          "karousel-focus-12" = [ ];
          "karousel-focus-2" = [ ];
          "karousel-focus-3" = [ ];
          "karousel-focus-4" = [ ];
          "karousel-focus-5" = [ ];
          "karousel-focus-6" = [ ];
          "karousel-focus-7" = [ ];
          "karousel-focus-8" = [ ];
          "karousel-focus-9" = [ ];
          "karousel-focus-down" = "Meta+J,none,Karousel: Move focus down";
          "karousel-focus-end" = "Meta+End,none,Karousel: Move focus to end";
          "karousel-focus-left" = [
            "Meta+H"
            "Meta+Left,none,Karousel: Move focus left"
          ];
          "karousel-focus-next" = [ ];
          "karousel-focus-previous" = [ ];
          "karousel-focus-right" = [
            "Meta+Right"
            "Meta+L,none,Karousel: Move focus right"
          ];
          "karousel-focus-start" = "Meta+Home,none,Karousel: Move focus to start";
          "karousel-focus-up" = [
            "Meta+K"
            "Meta+Up,none,Karousel: Move focus up"
          ];
          "karousel-grid-scroll-end" = "Meta+Alt+End,none,Karousel: Scroll to end";
          "karousel-grid-scroll-focused" = "Meta+Alt+Return,none,Karousel: Center focused window";
          "karousel-grid-scroll-left" = "Meta+Alt+PgUp,none,Karousel: Scroll left";
          "karousel-grid-scroll-left-column" = "Meta+Alt+A,none,Karousel: Scroll one column to the left";
          "karousel-grid-scroll-right" = "Meta+Alt+PgDown,none,Karousel: Scroll right";
          "karousel-grid-scroll-right-column" = "Meta+Alt+D,none,Karousel: Scroll one column to the right";
          "karousel-grid-scroll-start" = "Meta+Alt+Home,none,Karousel: Scroll to start";
          "karousel-screen-switch" =
            "Meta+Ctrl+Return,none,Karousel: Move Karousel grid to the current screen";
          "karousel-tail-move-to-desktop-1" =
            "Meta+Ctrl+Alt+Shift+F1,none,Karousel: Move this and all following columns to desktop 1";
          "karousel-tail-move-to-desktop-10" =
            "Meta+Ctrl+Alt+Shift+F10,none,Karousel: Move this and all following columns to desktop 10";
          "karousel-tail-move-to-desktop-11" =
            "Meta+Ctrl+Alt+Shift+F11,none,Karousel: Move this and all following columns to desktop 11";
          "karousel-tail-move-to-desktop-12" =
            "Meta+Ctrl+Alt+Shift+F12,none,Karousel: Move this and all following columns to desktop 12";
          "karousel-tail-move-to-desktop-2" =
            "Meta+Ctrl+Alt+Shift+F2,none,Karousel: Move this and all following columns to desktop 2";
          "karousel-tail-move-to-desktop-3" =
            "Meta+Ctrl+Alt+Shift+F3,none,Karousel: Move this and all following columns to desktop 3";
          "karousel-tail-move-to-desktop-4" =
            "Meta+Ctrl+Alt+Shift+F4,none,Karousel: Move this and all following columns to desktop 4";
          "karousel-tail-move-to-desktop-5" =
            "Meta+Ctrl+Alt+Shift+F5,none,Karousel: Move this and all following columns to desktop 5";
          "karousel-tail-move-to-desktop-6" =
            "Meta+Ctrl+Alt+Shift+F6,none,Karousel: Move this and all following columns to desktop 6";
          "karousel-tail-move-to-desktop-7" =
            "Meta+Ctrl+Alt+Shift+F7,none,Karousel: Move this and all following columns to desktop 7";
          "karousel-tail-move-to-desktop-8" =
            "Meta+Ctrl+Alt+Shift+F8,none,Karousel: Move this and all following columns to desktop 8";
          "karousel-tail-move-to-desktop-9" =
            "Meta+Ctrl+Alt+Shift+F9,none,Karousel: Move this and all following columns to desktop 9";
          "karousel-window-move-down" = "Meta+Shift+J,none,Karousel: Move window down";
          "karousel-window-move-end" = "Meta+Shift+End,none,Karousel: Move window to end";
          "karousel-window-move-left" = "Meta+Shift+H,none,Karousel: Move window left";
          "karousel-window-move-next" = [ ];
          "karousel-window-move-previous" = [ ];
          "karousel-window-move-right" = "Meta+Shift+L,none,Karousel: Move window right";
          "karousel-window-move-start" = "Meta+Shift+Home,none,Karousel: Move window to start";
          "karousel-window-move-to-column-1" = "Meta+Shift+1,none,Karousel: Move window to column 1";
          "karousel-window-move-to-column-10" = [ ];
          "karousel-window-move-to-column-11" = [ ];
          "karousel-window-move-to-column-12" = [ ];
          "karousel-window-move-to-column-2" = "Meta+Shift+2,none,Karousel: Move window to column 2";
          "karousel-window-move-to-column-3" = "Meta+Shift+3,none,Karousel: Move window to column 3";
          "karousel-window-move-to-column-4" = "Meta+Shift+4,none,Karousel: Move window to column 4";
          "karousel-window-move-to-column-5" = "Meta+Shift+5,none,Karousel: Move window to column 5";
          "karousel-window-move-to-column-6" = "Meta+Shift+6,none,Karousel: Move window to column 6";
          "karousel-window-move-to-column-7" = "Meta+Shift+7,none,Karousel: Move window to column 7";
          "karousel-window-move-to-column-8" = "Meta+Shift+8,none,Karousel: Move window to column 8";
          "karousel-window-move-to-column-9" = "Meta+Shift+9,none,Karousel: Move window to column 9";
          "karousel-window-move-up" = "Meta+Shift+K,none,Karousel: Move window up";
          "karousel-window-toggle-floating" = "Meta+F,none,Karousel: Toggle floating";
          "view_actual_size" = "Meta+=,Meta+0,Zoom to Actual Size";
          "view_zoom_in" = [
            "Meta++,Meta++"
            "Meta+=,Zoom In"
          ];
          "view_zoom_out" = "Meta+-";
        };
        mediacontrol = {
          mediavolumedown = "none,,Media volume down";
          mediavolumeup = "none,,Media volume up";
          nextmedia = "Media Next";
          pausemedia = "Media Pause";
          playmedia = "none,,Play media playback";
          playpausemedia = "Media Play";
          previousmedia = "Media Previous";
          stopmedia = "Media Stop";
        };
        org_kde_powerdevil = {
          "Decrease Keyboard Brightness" = "Keyboard Brightness Down";
          "Decrease Screen Brightness" = "Monitor Brightness Down";
          "Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
          "Hibernate" = "Hibernate";
          "Increase Keyboard Brightness" = "Keyboard Brightness Up";
          "Increase Screen Brightness" = "Monitor Brightness Up";
          "Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
          "PowerDown" = "Power Down";
          "PowerOff" = "Power Off";
          "Sleep" = "Sleep";
          "Toggle Keyboard Backlight" = "Keyboard Light On/Off";
          "Turn Off Screen" = [ ];
          "powerProfile" = [
            "Battery"
            "Meta+B,Battery"
            "Meta+B,Switch Power Profile"
          ];
        };
        plasmashell = {
          "Slideshow Wallpaper Next Image" = [ ];
          "activate application launcher" = [
            "Meta+Space,Meta"
            "Alt+F1,Activate Application Launcher"
          ];
          "activate task manager entry 1" = "none,Meta+1,Activate Task Manager Entry 1";
          "activate task manager entry 10" = "none,,Activate Task Manager Entry 10";
          "activate task manager entry 2" = "none,Meta+2,Activate Task Manager Entry 2";
          "activate task manager entry 3" = "none,Meta+3,Activate Task Manager Entry 3";
          "activate task manager entry 4" = "none,Meta+4,Activate Task Manager Entry 4";
          "activate task manager entry 5" = "none,Meta+5,Activate Task Manager Entry 5";
          "activate task manager entry 6" = "none,Meta+6,Activate Task Manager Entry 6";
          "activate task manager entry 7" = "none,Meta+7,Activate Task Manager Entry 7";
          "activate task manager entry 8" = "none,Meta+8,Activate Task Manager Entry 8";
          "activate task manager entry 9" = "none,Meta+9,Activate Task Manager Entry 9";
          "clear-history" = "none,,Clear Clipboard History";
          "clipboard_action" = "none,Meta+Ctrl+X,Automatic Action Popup Menu";
          "cycle-panels" = "Meta+Alt+P";
          "cycleNextAction" = "none,,Next History Item";
          "cyclePrevAction" = "none,,Previous History Item";
          "edit_clipboard" = "none,,Edit Contents…";
          "manage activities" = "none,Meta+Q,Show Activity Switcher";
          "next activity" = [ ];
          "previous activity" = [ ];
          "repeat_action" = "none,,Manually Invoke Action on Current Clipboard";
          "show dashboard" = "none,Ctrl+F12,Show Desktop";
          "show-barcode" = "none,,Show Barcode…";
          "show-on-mouse-pos" = "none,Meta+V,Show Clipboard Items at Mouse Position";
          "stop current activity" = "none,Meta+S,Stop Current Activity";
          "switch to next activity" = "none,,Switch to Next Activity";
          "switch to previous activity" = "none,,Switch to Previous Activity";
          "toggle do not disturb" = "none,,Toggle do not disturb";
        };
        "services/com.mitchellh.ghostty.desktop"."new-window" = "Meta+Return";
        "services/net.local.ghostty-2.desktop"."_launch" = "Meta+?";
        "services/org.kde.konsole.desktop"."_launch" = [ ];
        "services/org.kde.krunner.desktop"."_launch" = [
          "Alt+Space"
          "Search"
        ];
        "services/org.kde.kscreen.desktop"."ShowOSD" = "Display";
        "services/org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
        "services/org.kde.spectacle.desktop"."RecordRegion" = "Meta+Shift+R";
        "services/org.kde.spectacle.desktop"."RecordWindow" = [ ];
        "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+S";
        "services/org.kde.spectacle.desktop"."_launch" = "Print";
        "services/org.kde.touchpadshortcuts.desktop"."ToggleTouchpad" = [
          "Touchpad Toggle"
          "Meta+Ctrl+Zenkaku Hankaku"
        ];
        "services/systemsettings.desktop"."_launch" = "Meta+<";
      };
      configFile = {
        baloofilerc.General = {
          dbVersion = 2;
          "exclude filters" =
            "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
          "exclude filters version" = 9;
        };
        dolphinrc = {
          General.ViewPropsTimestamp = "2025,8,24,14,50,21.056";
          "KFileDialog Settings" = {
            "Places Icons Auto-resize" = false;
            "Places Icons Static Size" = 22;
          };
        };
        kcminputrc = {
          "Libinput/1133/16519/Logitech G903 LS"."NaturalScroll" = true;
          "Libinput/1267/12793/ELAN067C:00 04F3:31F9 Touchpad"."NaturalScroll" = true;
          "Libinput/76/613/Apple Inc. Magic Trackpad"."PointerAcceleration" = 0.400;
          "Libinput/76/613/Apple Inc. Magic Trackpad"."ScrollFactor" = 5;
        };
        kdeglobals = {
          General = {
            TerminalApplication = "ghostty";
            TerminalService = "com.mitchellh.ghostty.desktop";
          };
          KDE.AnimationDurationFactor = 0.17677669529663687;
          "KFileDialog Settings" = {
            "Allow Expansion" = false;
            "Automatically select filename extension" = true;
            "Breadcrumb Navigation" = false;
            "Decoration position" = 2;
            "Show Full Path" = false;
            "Show Inline Previews" = true;
            "Show Preview" = false;
            "Show Speedbar" = true;
            "Show hidden files" = false;
            "Sort by" = "Date";
            "Sort directories first" = true;
            "Sort hidden files last" = false;
            "Sort reversed" = false;
            "Speedbar Width" = 140;
            "View Style" = "DetailTree";
          };
          Shortcuts = {
            AboutApp = "";
            AboutKDE = "";
            Clear = "";
            ConfigureNotifications = "";
            ConfigureToolbars = "";
            Copy = "Ctrl+C; Meta+C; Ctrl+Ins";
            CreateFolder = "Meta+Shift+N; Ctrl+Shift+N";
            Cut = "Ctrl+X; Meta+X";
            Donate = "";
            EditBookmarks = "";
            FitToHeight = "";
            FitToPage = "";
            FitToWidth = "";
            Goto = "";
            GotoPage = "";
            Mail = "";
            New = "Ctrl+N; Meta+N";
            OpenRecent = "";
            Paste = "Ctrl+V; Shift+Ins; Meta+V";
            Preferences = "Meta+,; Ctrl+Shift+,";
            PrintPreview = "";
            ReportBug = "";
            Revert = "";
            Save = "Ctrl+S; Meta+S";
            SaveAs = "Ctrl+Shift+S; Meta+Shift+S";
            ShowStatusbar = "";
            ShowToolbar = "";
            Spelling = "";
            SwitchApplicationLanguage = "";
            Zoom = "";
          };
          WM = {
            activeBackground = "30,30,46";
            activeBlend = "205,214,244";
            activeForeground = "205,214,244";
            inactiveBackground = "17,17,27";
            inactiveBlend = "166,173,200";
            inactiveForeground = "166,173,200";
          };
        };
        kscreenlockerrc = {
          Daemon.Timeout = 10;
          Greeter.WallpaperPlugin = "org.kde.potd";
          "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
        };
        kwalletrc.Wallet."First Use" = false;
        kwinrc = {
          Desktops = {
            "Id_1" = "f2a60743-1874-4a2e-80cd-8595c3bb1899";
            "Id_2" = "feffcc45-ea46-4724-bf1f-cac62d951733";
            "Id_3" = "3ce97ee5-7a5a-440f-aaba-b24059cfba57";
            "Id_4" = "9ce0f43c-ff5e-4423-aed4-6f7a80518ad4";
            "Id_5" = "8b4130a7-9668-4f64-abfa-cf07892a5962";
            "Id_6" = "8c9e427e-2fcf-4498-ac17-ea36564430be";
            "Number" = 6;
            "Rows" = 1;
          };
          Effect-overview.BorderActivate = 9;
          ElectricBorders.BottomRight = "LockScreen";
          Plugins = {
            fadedesktopEnabled = true;
            karouselEnabled = true;
            magnifierEnabled = true;
            screenedgeEnabled = false;
            slideEnabled = false;
            slidingpopupsEnabled = false;
            zoomEnabled = false;
          };
          Script-karousel = {
            floatingKeepAbove = true;
            presetWidths = "50%, 30%, 70%";
            reMaximize = true;
            tiledKeepBelow = false;
            windowRules = "[\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?plasmashell\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?polkit-kde-authentication-agent-1\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?kded6\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?kcalc\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?kfind\",\n        \"tile\": true\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?kruler\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?krunner\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"(org\\\\.kde\\\\.)?yakuake\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"steam\",\n        \"caption\": \"Steam Big Picture Mode\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"zoom\",\n        \"caption\": \"Zoom Cloud Meetings|zoom|zoom <2>\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"jetbrains-.*\",\n        \"caption\": \"splash\",\n        \"tile\": false\n    },\n    {\n        \"class\": \"jetbrains-.*\",\n        \"caption\": \"Unstash Changes|Paths Affected by stash@.*\",\n        \"tile\": true\n    },\n    {\n        \"class\": \"com.mitchellh.ghostty-popup\",\n        \"tile\": false\n    }\n]";
          };
          Xwayland.Scale = 1.75;
          "org.kde.kdecoration2" = {
            BorderSize = "NoSides";
            BorderSizeAuto = false;
            theme = "Breeze";
          };
        };
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."Description" =
          "Window settings for com.mitchellh.ghostty";
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."noborder" = true;
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."noborderrule" = 3;
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."title" = "mwork: ~/S/r/a/tectonics";
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."types" = 1;
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."wmclass" = "ghostty com.mitchellh.ghostty";
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."wmclasscomplete" = true;
        "kwinrulesrc"."0890b4cc-54cf-408f-bbe6-a37ebd42858a"."wmclassmatch" = 1;
        "kwinrulesrc"."8dcedf51-5cf8-421e-b548-d563a7d77dc4"."noborderrule" = 3;
        "kwinrulesrc"."General"."count" = 2;
        "kwinrulesrc"."General"."rules" =
          "e211d755-ce95-4f95-91c4-62ba5b483170,0890b4cc-54cf-408f-bbe6-a37ebd42858a";
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."Description" =
          "Window settings for com.mitchellh.ghostty-popup";
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."above" = true;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."aboverule" = 3;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."noborder" = true;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."noborderrule" = 3;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."placementrule" = 2;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."title" = "Ghostty";
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."types" = 1;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."wmclass" =
          "ghostty com.mitchellh.ghostty-popup";
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."wmclasscomplete" = true;
        "kwinrulesrc"."e211d755-ce95-4f95-91c4-62ba5b483170"."wmclassmatch" = 1;
        plasma-localerc.Formats = {
          LANG = "en_US.UTF-8";
          LC_ADDRESS = "C";
          LC_MEASUREMENT = "nb_NO.UTF-8";
          LC_MONETARY = "nb_NO.UTF-8";
          LC_NAME = "C";
          LC_NUMERIC = "nb_NO.UTF-8";
          LC_PAPER = "nb_NO.UTF-8";
          LC_TELEPHONE = "C";
          LC_TIME = "en_DK.UTF-8";
        };
        plasmaparc = {
          General.GlobalMute = true;
          Wallpapers.usersWallpapers = "/etc/nixos/wallpaper/Cloudsnight.jpg";
        };
        spectaclerc = {
          ImageSave.translatedScreenshotsFolder = "Screenshots";
          VideoSave.translatedScreencastsFolder = "Screencasts";
        };
      };
    };
  };
}
