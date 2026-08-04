{ pkgs, lib, ... }:
{
  imports = [

    ../../nixos/dmsmobile.nix
  ];
  environment = {
    variables.GTK_IM_MODULE = lib.mkForce "wayland";
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
    ];
  };
  networking.hostName = "dmsMobile";
  console.font = "solar24x32";

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
