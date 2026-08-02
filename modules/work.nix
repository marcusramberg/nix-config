{ lib, config, ... }:
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
  };
}
