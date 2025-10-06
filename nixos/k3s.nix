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
    staticIP = {
      enable = mkEnableOption "Enable static IP";
      ip = mkOption {
        type = types.str;
        description = "tailscale ip";
      };
    };
    role = mkOption {
      type = types.str;
      default = "server";
      description = "k3s role";
    };
    tailscale = {
      enable = mkEnableOption "Enable tailscale";
      ip = mkOption {
        type = types.str;
        description = "tailscale ip";
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        openiscsi
      ];
    };
    services.k3s = {
      enable = true;
      tokenFile = config.age.secrets.k3s-token.path;
      inherit (cfg) role;
      extraFlags =
        lib.optionals cfg.tailscale.enable [
          "--node-external-ip=${cfg.tailscale.ip}"
          "--flannel-backend=wireguard-native"
          "--flannel-external-ip ${cfg.tailscale.ip}"
        ]
        ++ lib.optionals cfg.staticIP.enable [
          "--node-ip"
          cfg.staticIP.ip
        ]
        ++ lib.optionals (cfg.role == "server") [
          "--disable traefik"
          "--write-kubeconfig-mode=640"
          "--write-kubeconfig-group=wheel"
        ];

    };
    networking.firewall = {
      allowedTCPPorts = [
        2379
        2380
        6443
        10250
      ];
      allowedUDPPorts = [ 8472 ];
      trustedInterfaces = [ "flannel.1" ];
    };
  };
}
