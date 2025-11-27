{ config, ... }:
with config.lib.niri.actions;
let
  dms-ipc = spawn "dms" "ipc";
in
{
  "Mod+Return".action = spawn "ghostty";
  "Mod+Space" = {
    action = dms-ipc "spotlight" "toggle";
    hotkey-overlay.title = "Toggle Application Launcher";
  };
  "Mod+Shift+Comma" = {
    action = dms-ipc "settings" "toggle";
    hotkey-overlay.title = "Toggle Settings";
  };
  "Mod+Ctrl+Shift+Alt+L".action = dms-ipc "lock" "lock";
  "Mod+E".action = spawn "dolphin";
  "Mod+Alt+V" = {
    action = dms-ipc "clipboard" "toggle";
  };

  XF86AudioRaiseVolume = {
    allow-when-locked = true;
    action = spawn "pamixer" "-i" "5";
  };
  XF86AudioLowerVolume = {
    allow-when-locked = true;
    action = spawn "pamixer" "-d" "5";
  };
  XF86AudioMute = {
    allow-when-locked = true;
    action = spawn "pamixer" "-t";
  };
  # XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

  # // Example brightness key mappings for brightnessctl.
  # // You can use regular spawn with multiple arguments too (to avoid going through "sh"),
  # // but you need to manually put each argument in separate "" quotes.
  # XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
  # XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

  "Mod+Shift+Q" = {
    action = close-window;
    repeat = false;
  };

  "Mod+K".action = focus-window-or-workspace-up;
  "Mod+H".action = focus-column-left;
  "Mod+J".action = focus-window-or-workspace-down;
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

  "Mod+Shift+Minus".action = set-window-height "-10%";
  "Mod+Shift+Equal".action = set-window-height "+10%";

  "Mod+F".action = toggle-window-floating;
  "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

  "Mod+Shift+S".action = spawn "grimshot" "--notify" "save" "area" "-" "|" "satty" "-f" "-";
  "Mod+Ctrl+S".action = spawn "grimshot" "--notify" "save" "output" "-" "|" "satty" "-f" "-";

  "Mod+Escape" = {
    allow-inhibiting = false;
    action = toggle-keyboard-shortcuts-inhibit;
  };

  "Mod+Shift+E".action = quit;
  "Mod+1".action = focus-workspace 1;
  "Mod+2".action = focus-workspace 2;
  "Mod+3".action = focus-workspace 3;
  "Mod+4".action = focus-workspace 4;
  "Mod+5".action = focus-workspace 5;
  "Mod+6".action = focus-workspace 6;
  "Mod+7".action = focus-workspace 7;
  "Mod+8".action = focus-workspace 8;
  "Mod+Shift+1".action = move-column-to-index 1;
  "Mod+Shift+2".action = move-column-to-index 2;
  "Mod+Shift+3".action = move-column-to-index 3;
  "Mod+Shift+4".action = move-column-to-index 4;
  "Mod+Shift+5".action = move-column-to-index 5;
  "Mod+Shift+6".action = move-column-to-index 6;
  "Mod+Shift+7".action = move-column-to-index 7;
  "Mod+Shift+8".action = move-column-to-index 8;
}
