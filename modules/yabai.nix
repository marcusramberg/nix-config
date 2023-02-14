{ pkgs, lib, config, secrets, ... }:
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "off";
      mouse_follows_focus = "on";
      window_placement = "second_child";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      window_border = "on";
      window_border_placement = "inset";
      window_border_width = 1;
      window_border_radius = 2;
      active_window_border_topmost = "off";
      window_topmost = "on";
      window_shadow = "float";
      active_window_border_color = "0xffB48EAD";
      normal_window_border_color = "0xff5E81AC";
      insert_window_border_color = "0xffD08770";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_modifier = "ctrl";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
      echo "yabai configuration loaded.."
    '';
  };
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # toggle window native fullscreen
      ctrl - e : yabai -m space --layout bsp
      ctrl - s : yabai -m space --layout stack

      ctrl + shift + alt + cmd - j : yabai -m window --focus stack.next || yabai -m window --focus south
      ctrl + shift + alt + cmd - k : yabai -m window --focus stack.prev || yabai -m window --focus north
      ctrl + shift + alt + cmd - h : yabai -m window --focus west
      ctrl + shift + alt + cmd - l : yabai -m window --focus east

      ctrl + shift - 1 : yabai -m window --space 1
      ctrl + shift - 2 : yabai -m window --space 2
      ctrl + shift - 3 : yabai -m window --space 3
      ctrl + shift - 4 : yabai -m window --space 4
      ctrl + shift - 5 : yabai -m window --space 5
      ctrl + shift - 6 : yabai -m window --space 6
      ctrl + shift - 7 : yabai -m window --space 7
      ctrl + shift - 8 : yabai -m window --space 8
      ctrl + shift - 9 : yabai -m window --space 9

      cmd + ctrl + shift + alt - f : yabai -m window --toggle float

      cmd - return : wezterm start

      ctrl + shift + alt + cmd - m : yabai -m display --focus next | yabai -m display --focus first
      ctrl + shift + alt + cmd - n : yabai -m space --display next | yabai -m space --display first
    '';
  };
}
