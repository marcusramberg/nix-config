{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.gaming;
in
{
  options.profiles.gaming.enable = mkEnableOption "Gaming profile";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
      teeworlds
    ];
    programs = {
      steam.enable = true;
    };

  };
}
