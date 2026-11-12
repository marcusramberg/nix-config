{ pkgs, lib, ... }:
{
  imports = [

    ../../nixos/dmsmobile.nix
  ];
  documentation.nixos.enable = false;
  environment = {
    variables.GTK_IM_MODULE = lib.mkForce "wayland";
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
    ];
  };
  # unl0kr owns the display in the initrd here; Plymouth would blank the LUKS prompt.
  boot = {
    plymouth.enable = false;
    consoleLogLevel = lib.mkForce 7;
  };

  vanilla-mobile = {
    device.oneplus-fajita.enable = true;
    # dux-shell inhibits sleep for MPRIS itself; this one polls playerctl every second.
    powerManagement.sleepInhibitors.mpris.enable = false;
  };
  # Matches the partition labels of the image the phone was flashed with.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-boot";
      fsType = "vfat";
    };
  };

  boot.kernelPatches = [
    {
      name = "synaptics-s3706b";
      patch = ./synaptics-s3706b.patch;
    }
    # vanilla's 7.1 kernel doesn't build against nixpkgs' 7.3 headers.
    {
      name = "tools-u128";
      patch = ./tools-u128.patch;
    }
  ];

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  nix = {
    buildMachines = [
      {
        system = "aarch64-linux";
        sshUser = "marcus";
        hostName = "mstudio";
        protocol = "ssh-ng";
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 4;
      }
    ];
    settings = {
      max-jobs = 0;
    };
  };
  programs.springchick.enable = true;
  programs.niri.enable = true;
  profiles = {
    dmsMobile.enable = true;
    myfonts.enable = true;
  };
  services = {
    desktopManager = {
      gnome.enable = true;
    };
    # GNOME brings power-profiles-daemon; vanilla-mobile defaults to TLP.
    tlp.enable = false;
  };
}
