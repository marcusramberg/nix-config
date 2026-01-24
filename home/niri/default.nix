{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNiri = (lib.hasAttr "programs" osConfig) && osConfig.programs.niri.enable;
in
{
  home = mkIf isNiri {
    packages = with pkgs; [
      xwayland-satellite
      libnotify
      satty
      wvkbd
    ];
  };
  programs = mkIf isNiri {
  };
  qt = {
    enable = true;
    qt5ctSettings.Appearance.icon_theme = "breeze-dark";
    qt6ctSettings.Appearance.icon_theme = "breeze-dark";
  };
}
