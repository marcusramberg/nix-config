{ config, ... }:
with config.lib.niri.actions;
let
  dms-ipc = spawn "dms" "ipc";
  vicinae = spawn "vicinae";
in
{
  "Mod+Return" = {
    action = spawn "ghostty";
    hotkey-overlay.title = "Open Terminal Emulator";
  };
  "Mod+Space" = {
    action = vicinae "toggle";
    hotkey-overlay.title = "Toggle Application Launcher";
  };
  "Mod+Shift+Comma" = {
    action = dms-ipc "settings" "toggle";
    hotkey-overlay.title = "Toggle Settings";
  };
  "Mod+Ctrl+Shift+Alt+L" = {
    action = dms-ipc "lock" "lock";
    hotkey-overlay.title = "Lock Screen";
  };
  "Mod+E" = {
    action = spawn "dolphin";
    hotkey-overlay.title = "Open File Manager";
  };
  "Mod+Shift+Slash".action = show-hotkey-overlay;
  "Mod+G" = {
    action = vicinae "vicinae://extensions/josephschmitt/gif-search/search";
    hotkey-overlay.title = "Open GIF Search";
  };
  "Mod+Alt+V" = {
    hotkey-overlay.title = "Toggle Clipboard Manager";
    action = dms-ipc "clipboard" "toggle";
  };

  XF86AudioRaiseVolume = {
    allow-when-locked = true;
    action = dms-ipc "audio" "increment" "5";
  };
  XF86AudioLowerVolume = {
    allow-when-locked = true;
    action = dms-ipc "audio" "decrement" "5";
  };
  XF86AudioMute = {
    allow-when-locked = true;
    action = dms-ipc "audio" "mute";
  };
  XF86AudioMicMute = {
    allow-when-locked = true;
    action = dms-ipc "audio" "toggle-mic-mute";
  };
  XF86MonBrightnessUp = {
    allow-when-locked = true;
    action = dms-ipc "brightness" "increment" "10" "backlight:intel_backlight";
  };
  XF86MonBrightnessDown = {
    allow-when-locked = true;
    action = dms-ipc "brightness" "decrement" "10" "backlight:intel_backlight";
  };
  XF86AudioPlay = {
    allow-when-locked = true;
    action = dms-ipc "mpris" "playPause";
  };
  XF86AudioStop = {
    allow-when-locked = true;
    action = dms-ipc "mpris" "pause";
  };
  XF86AudioNext = {
    allow-when-locked = true;
    action = dms-ipc "mpris" "next";
  };
  XF86AudioPrev = {
    allow-when-locked = true;
    action = dms-ipc "mpris" "previous";
  };

  "Mod+B" = {
    action = dms-ipc "bar" "toggle" "1";
    hotkey-overlay.title = "Toggle Top Bar";
  };

  "Mod+Shift+Q" = {
    action = close-window;
    repeat = false;
  };

  "Mod+K" = {
    action = focus-window-or-workspace-up;
    hotkey-overlay.title = "Focus Window or Workspace Up";
  };
  "Mod+H".action = focus-column-left;
  "Mod+J" = {
    action = focus-window-or-workspace-down;
    hotkey-overlay.title = "Focus Window or Workspace Down";
  };
  "Mod+L".action = focus-column-right;

  "Mod+Shift+K".action = move-column-to-workspace-up;
  "Mod+Shift+H".action = move-column-left;
  "Mod+Shift+J".action = move-column-to-workspace-down;
  "Mod+Shift+L".action = move-column-right;

  "Mod+grave".action = toggle-overview;

  "Mod+Home".action = focus-column-first;
  "Mod+End".action = focus-column-last;
  "Mod+Shift+Home".action = move-column-to-first;
  "Mod+Shift+End".action = move-column-to-last;

  "Mod+Ctrl+K".action = focus-monitor-up;
  "Mod+Ctrl+H".action = focus-monitor-left;
  "Mod+Ctrl+J".action = focus-monitor-down;
  "Mod+Ctrl+L".action = focus-monitor-right;

  "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
  "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
  "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
  "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

  "Mod+O".action = consume-or-expel-window-left;
  "Mod+P".action = consume-or-expel-window-right;

  "Mod+Shift+O".action = consume-window-into-column;
  "Mod+Shift+P".action = expel-window-from-column;

  "Mod+R".action = switch-preset-column-width;
  "Mod+Shift+R".action = switch-preset-window-height;
  "Mod+Ctrl+R".action = reset-window-height;

  "Mod+M".action = maximize-column;
  "Mod+Shift+M".action = fullscreen-window;
  "Mod+Ctrl+M".action = expand-column-to-available-width;

  "Mod+Y".action = move-workspace-to-monitor-next;
  "Mod+Shift+Y".action = move-workspace-to-monitor-previous;

  "Mod+Shift+Minus".action = set-window-height "-10%";
  "Mod+Shift+Equal".action = set-window-height "+10%";

  "Mod+F".action = toggle-window-floating;
  "Mod+Shift+F".action = switch-focus-between-floating-and-tiling;

  "Mod+Shift+S" = {
    action = spawn "grimshot" "--notify" "savecopy" "area";
    hotkey-overlay.title = "Take Area Screenshot";
  };
  "Mod+Ctrl+S" = {
    action = spawn "grimshot" "--notify" "savecopy" "output";
    hotkey-overlay.title = "Take Fullscreen Screenshot";
  };

  "Mod+Escape" = {
    allow-inhibiting = false;
    action = toggle-keyboard-shortcuts-inhibit;
  };

  "Mod+Shift+E".action = quit;
  "Mod+1".action.focus-workspace = "terminal";
  "Mod+2".action.focus-workspace = "browser";
  "Mod+3".action.focus-workspace = "music";
  "Mod+4".action.focus-workspace = "chat";
  "Mod+5".action.focus-workspace = 5;
  "Mod+6".action.focus-workspace = 6;
  "Mod+7".action.focus-workspace = 7;
  "Mod+8".action.focus-workspace = 8;
  "Mod+Shift+1".action.move-column-to-workspace = "terminal";
  "Mod+Shift+2".action.move-column-to-workspace = "browser";
  "Mod+Shift+3".action.move-column-to-workspace = "music";
  "Mod+Shift+4".action.move-column-to-workspace = "chat";
  "Mod+Shift+5".action.move-column-to-workspace = 5;
  "Mod+Shift+6".action.move-column-to-workspace = 6;
  "Mod+Shift+7".action.move-column-to-workspace = 7;
  "Mod+Shift+8".action.move-column-to-workspace = 8;
}
