{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.profiles.work;
in
{

  options.profiles.work = {
    enable = mkEnableOption "Work Machine";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      act
      amazon-ecr-credential-helper
      docker-credential-gcr
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.spanner-cli
      ])
      kubectx
      slack
      ssh-tpm-agent
    ];
    services = {
      cloudflare-warp.enable = true;
    };

    # Tailscale between two WARP hosts picks the peer's WARP IPv6 address as a
    # "direct" endpoint. WARP's MTU is 1280, so after WireGuard-over-IPv6
    # overhead (80 bytes) only 1200-byte inner packets fit, while tailscale0
    # advertises 1280. Larger packets are silently dropped (ssh hangs in KEX).
    # Clamp TCP MSS on tailscale0 to fit: 1200 - 40 (IPv6) - 20 (TCP) = 1140.
    # Only fixes TCP; the real fix is excluding 2606:4700:cf1:1000::/64 from
    # the WARP split tunnel so tailscale stops using that path.
    networking.nftables.tables.tailscale-warp-mss = {
      family = "inet";
      content = ''
        chain prerouting {
          type filter hook prerouting priority mangle; policy accept;
          iifname "tailscale0" tcp flags syn tcp option maxseg size > 1140 tcp option maxseg size set 1140
        }
        chain postrouting {
          type filter hook postrouting priority mangle; policy accept;
          oifname "tailscale0" tcp flags syn tcp option maxseg size > 1140 tcp option maxseg size set 1140
        }
      '';
    };
  };
}
