{ config, lib, ... }:
with lib;
let cfg = config.hardware.gpu.nvidia;
in {
  options.profiles.gaming.enable = mkEnableOption "Gaming profile";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ heroic teeworlds ];
    programs = { steam.enable = true; };

  };
}
