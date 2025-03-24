{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.profiles.kodi;
in
{
  options.profiles.kodi = {
    enable = mkEnableOption "Kodi media center";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi.withPackages (
          p: with p; [
            kodi-platform
            youtube
          ]
        );
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeters.tiny.enable = true;
        };
        defaultSession = "kodi";
        autoLogin.enable = true;
        autoLogin.user = "marcus";
      };
    };
  };
}
