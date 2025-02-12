{ pkgs, ... }:
{

  environment = {
    systemPackages = with pkgs; [
      (google-cloud-sdk.withExtraComponents (
        with pkgs.google-cloud-sdk.components;
        [
          cloud-build-local
          gke-gcloud-auth-plugin
        ]
      ))
    ];
  };
}
