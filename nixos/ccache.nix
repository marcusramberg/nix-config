{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.profiles.ccache;
in
{
  options.profiles.ccache = {
    enable = mkEnableOption "Host ccache on this machine";
  };
  config = mkIf cfg.enable {
    nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];
    programs.ccache.enable = true;
    # upstream ships a setgid perl script, rejected by ensure-wrapper-integrity
    security.wrappers.nix-ccache.enable = false;
  };
}
