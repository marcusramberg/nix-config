{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.profiles.passthrough;
in {
  options.profiles.passthrough = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "GPU Passthrough support";
    };
    hardware-ids = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of hardware IDs to enable passthrough for";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [ "nvidia" "nouveau" ];
      kernelParams = [
        "intel_iommu=on"
        ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.hardware-ids)
      ];
      kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      libguestfs # needed to virt-sparsify qcow2 files
    ];

    virtualisation = {
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
  };
}