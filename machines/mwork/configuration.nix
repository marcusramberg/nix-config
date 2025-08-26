{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    # binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.luks.devices."luks-9de8d567-1ec4-4d2f-896b-a0f6711d4d44".device =
      "/dev/disk/by-uuid/9de8d567-1ec4-4d2f-896b-a0f6711d4d44";
  };
  environment.systemPackages = with pkgs; [
    act
    amazon-ecr-credential-helper
    docker-credential-gcr
    discord
    fuzzel
    (google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    slack
    spotify
    tuba
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
        device = "platform-i8042-serio-0-event-kbd";
      };
    };
  };

  # fingerprint readre
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # Install the driver
  services.fprintd.enable = true;
  security.pam.services = {
    login.unixAuth = true;
    # fprint is not stable, locked sometimes after suspend
    login.fprintAuth = false;
    sddm.fprintAuth = false;
    xscreensaver.fprintAuth = true;
    kwallet.fprintAuth = true;
  };

  # Enable networking
  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [ ];
    wifi.backend = "iwd";
  };

  profiles = {
    autoupgrade.enable = true;
    desktop.enable = true;
    dockerHost.enable = true;
  };
  services = {
    cloudflare-warp.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
