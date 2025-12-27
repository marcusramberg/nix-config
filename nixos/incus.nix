{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.incus;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.incus = {
    enable = mkEnableOption "Incus node";
  };
  config = mkIf cfg.enable {

    networking.firewall = {
      trustedInterfaces = [
        "incusbr0"
      ];
    };
    virtualisation.incus = {
      enable = true;
      ui.enable = true;
      package = pkgs.incus;
    };
  };
}
