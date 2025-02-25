{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];
  networking.hostName = "butterbee"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    systemPackages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [
        pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
    ];
  };

  nix.package = pkgs.nixVersions.nix_2_26;
  hardware.enableAllFirmware = true;

  profiles = {
    desktop.enable = true;
    dockerHost.enable = true;
    hyprland.enable = true;
  };

  services = {
    displayManager.sddm.enableHidpi = true;
    cloudflare-warp.enable = true;
    pulseaudio.enable = false;
    resolved.enable = true;
    xserver.dpi = 140;
  };
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.user.services.warp-taskbar.wantedBy = [ "graphical.target" ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  networking.extraHosts = ''
    10.211.55.2 mbook
    0.0.0.0 vg.no www.vg.no
  '';
}
