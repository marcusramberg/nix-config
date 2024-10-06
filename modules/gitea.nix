{ lib, config, ... }:
with lib;
let
  cfg = config.profiles.gitea;
in
{

  options.profiles.gitea = {
    enable = mkEnableOption "Gitea server";
    host = mkOption {
      type = types.str;
      description = "Domain name for the Gitea server";
      default = "git.means.no";
    };

  };

  config = mkIf cfg.server.enable { };
  services.gitea = {
    enable = true;
    settings.service.ROOT_URL = cfg.host;
  };
}
