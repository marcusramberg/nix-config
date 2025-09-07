{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 4;
        secureBoot.enable = true;
        style = {
          interface = {
            branding = "if found, please return to Marcus Ramberg - 94357747";
            resolution = "1920x1200";
          };
          graphicalTerminal = {
            palette = "4c4f69;d20f39;40a02b;dc8a78;1e66f5;ea76cb;209fb5;7c7f93";
            font.scale = "2x2";
          };
          wallpapers = [
            "${pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath}"
          ];
        };
      };
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
  services = {
    fprintd.enable = true;
    envfs.enable = true;
  };
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
    udev.extraRules = ''
      # DFU (Internal bootloader for STM32 and AT32 MCUs)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
    '';
  };
}
