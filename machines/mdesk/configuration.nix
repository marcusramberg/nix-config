{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf".device =
      "/dev/disk/by-uuid/1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf";
  };

  environment.systemPackages = with pkgs; [
    act
    amazon-ecr-credential-helper
    docker-credential-gcr
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.spanner-cli
    ])
    plexamp
    slack
    spotify
    woodpecker-cli
    ssh-tpm-agent
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    keyboard.dual-caps = {
      enable = true;
      swapAlt = {
        enable = true;
        devices = [
          "/dev/input/by-id/usb-Logitech_USB_Receiver-event-kbd"
          "/dev/input/by-id/usb-SDINNOVATION_Gaming_Keyboard_003123456789-event-kbd"
        ];
      };
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "mdesk";
  };

  profiles = {
    incus.enable = true;
  };

  services = {
    cloudflare-warp.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
    podman.enable = true;
  };

}
