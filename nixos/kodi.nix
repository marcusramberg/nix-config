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
    services.avahi.enable = true;
    services.xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi.withPackages (
          p: with p; [
            invidious
            kodi-platform
            libretro-2048
            mediacccde
            netflix
            pvr-iptvsimple
            sendtokodi
            somafm
            vfs-sftp
            visualization-matrix
            visualization-projectm
            visualization-shadertoy
            visualization-spectrum
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
