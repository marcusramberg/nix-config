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
  networking.hostName = "dmsMobile";
  console.font = "solar24x32";

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
  };
  nixos-fairphone-fp5 = {
    modem.enable = true;
    usb-signaller.enable = true;
    # Reach to the fingerprint sensor's trusted application over the QSEECOM
    # TEE driver: loads the sensor's GPIO/IRQ driver, installs the trusted
    # application image, and provides `ftharness` to drive it. This is not
    # working fingerprint authentication -- the application still needs a
    # supplicant for its file service before it can enrol or match.
    fingerprint = {
      enable = true;
      fprintd = true;
    };
  };

  # Don't block boot ~9.5s waiting for wifi (ath11k rproc probe defers wlan0 late).
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
  profiles = {
    dmsMobile.enable = true;
    myfonts.enable = true;
  };
  services = {
    desktopManager = {
      gnome.enable = true;
    };
  };
}
