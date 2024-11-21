{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.profiles.k3s;
in
{
  options.profiles.k3s = {
    enable = mkEnableOption "Kubernetes node";
    tailscale = {
      enable = mkEnableOption "Enable tailscale";
      ip = mkOption {
        type = types.str;
        description = "tailscale ip";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openiscsi
    ];
    services.k3s = {
      enable = true;
      tokenFile = config.age.secrets.k3s-token.path;
      extraFlags =
        [
          "--disable traefik"
          "--write-kubeconfig-mode=644"
        ]
        ++ lib.optionals cfg.tailscale.enable [
          "--node-external-ip=${cfg.tailscale.ip}"
          "--flannel-backend=wireguard-native"
          "--flannel-external-ip ${cfg.tailscale.ip}"
        ];
    };
  };
}
