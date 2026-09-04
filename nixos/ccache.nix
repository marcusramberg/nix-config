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
    enable = mkEnableOption "ccache";
  };
  config = mkIf cfg.enable {
    nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];
    programs.ccache.enable = true;
  };
}
