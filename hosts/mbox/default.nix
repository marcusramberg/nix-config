{ lib, pkgs, ... }:

let gpuIDs = [ "8086:1901" "10de:1f08" "10de:10f9" "10de:1ada" "10de:1adb" ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop.nix
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
    kernel.sysctl."net.ipv4.ip_forward" = 1;

    kernelParams =
      [ "intel_iommu=on" ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs) ];

    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
    extraModprobeConfig = "options kvm_intel nested=1";
  };

  programs.steam.enable = true;

  services = {
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
