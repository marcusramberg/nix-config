{ pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile
    initrd = {
      secrets = { "/crypto_keyfile.bin" = null; };
      # Enable swap on luks
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".device =
        "/dev/disk/by-uuid/0050060b-f9cb-4697-8934-aef2f5ad0e2a";
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".keyFile =
        "/crypto_keyfile.bin";
    };

    kernelParams = [ "fbcon=map:1" ];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [ "fbcon" "hid-apple" ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options kvm_intel nested=1
    '';
  };
  environment.systemPackages = [ pkgs.zigpkgs.master ];

  networking = {
    extraHosts = ''
      10.211.55.2 mbook
      0.0.0.0 vg.no www.vg.no
    '';
    hostName = "mbox";
    networkmanager.enable = true;
  };

  fileSystems."/home/marcus/org" = {
    device = "mspace:/volume1/homes/marcus/Drive/orgmode";
    fsType = "nfs4";
    options = [ "nfsvers=4.1" "soft" ];
  };

  hardware = {
    gpu.amd.enable = true;
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
  };

  profiles = {
    nimdow.enable = true;
    hyprland.enable = true;
    dockerHost.enable = true;
    gaming.enable = true;
    k3s.enable = true;
    passthrough = {
      enable = true;
      hardware-ids = [
        "8086:1901"
        "10de:1f08"
        "10de:10f9"
        "10de:1ada"
        "10de:1adb" # nvidia
        "144d:a808" # NVME
        "10ec:8168" # network adapter
      ];
    };
  };

  programs = {
    custom.ddcutil = {
      enable = true;
      user = "marcus";
    };
  };

  programs.streamdeck-ui = {
    enable = true;
    autoStart = true;
  };

  services = {
    below.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    tailscale.useRoutingFeatures = "server";
    ollama = {
      listenAddress = "0.0.0.0";
      enable = true;
    };

    xserver.dpi = 144;
    # Deckmaster
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-mini"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-xl"
    '';
  };
  virtualisation = {
    docker.enable = true;
    incus.enable = true;
  };
}

