{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNiri =
    (lib.hasAttr "programs" osConfig)
    && (osConfig.programs.niri.enable || (osConfig.programs.mango.enable or false));
  isFjordxy = (osConfig.profiles.desktop.shell or "dux") == "fjordxy";
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
  qt = mkIf (!isFjordxy) {
    enable = true;
    qt5ctSettings.Appearance.icon_theme = "breeze-dark";
    qt6ctSettings.Appearance.icon_theme = "breeze-dark";
  };
}
