{ lib, config, ... }:
with lib;
let
  cfg = config.profiles.k3s;
in
{
  options.profiles.k3s = {
    enable = mkEnableOption "Kubernetes node";
  };

  config = mkIf cfg.enable {
    services.k3s = {
      enable = true;
      tokenFile = config.age.secrets.k3s-token.path;
      extraFlags = "--write-kubeconfig-mode=644";
    };
  };
}
