{
  config,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.profiles.autoupgrade;
in
{
  options.profiles.autoupgrade = {
    enable = mkEnableOption "autoupgrade";
  };
  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
