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
  services.spacebar.enable = false;
  services.spacebar.package = pkgs.spacebar;
  services.spacebar.config = {
    clock_format = "%R";
    space_icon_strip = "   ";
    text_font = ''"Helvetica Neue:Bold:12.0"'';
    icon_font = ''"FontAwesome:Regular:12.0"'';
    background_color = "0xff202020";
    foreground_color = "0xffa8a8a8";
    power_icon_strip = " ";
    space_icon = "";
    clock_icon = "";
  };
}
