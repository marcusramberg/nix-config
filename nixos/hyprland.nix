{ config, pkgs, lib, ... }:
with lib;
let cfg = config.profiles.hyprland;
in {
  options.profiles.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dolphin hyprpaper waybar wofi ];

    profiles.desktop.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

  };
}
