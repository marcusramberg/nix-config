{ lib, pkgs, ... }:

let
  gpuIDs = [
    "8086:1901"
    "10de:1f08"
    "10de:10f9"
    "10de:1ada"
    "10de:1adb" # nvidia
    "144d:a808" # nvme
    "10ec:8168" # network adapter
  ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/keyboardmap.nix
    ../../modules/pipewire.nix
    ../../modules/amd.nix
  ];

  # Add for virtualisation
  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs # needed to virt-sparsify qcow2 files
    deckmaster
  ];

  networking = {
    extraHosts = ''
      10.211.55.2 mbook
      0.0.0.0 vg.no www.vg.no
    '';
    hostName = "mbox";
    networkmanager.enable = true;
  };

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

    kernelParams = [
      "intel_iommu=on"
      "fbcon=map:1"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
    ];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vfio_virqfd"
      "fbcon"
      "hid-apple"
    ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options kvm_intel nested=1
    '';
  };
  hardware.bluetooth.enable = true;

  profiles = { nimdow.enable = true; };

  programs = {
    steam.enable = true;
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
    blueman.enable = true;
    flatpak.enable = true;
    tailscale.useRoutingFeatures = "server";
    xserver.dpi = 144;
    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-mini"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-xl"
    '';
  };

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        ovmf.enable = true;
        runAsRoot = true;
      };
    };
  };
}

