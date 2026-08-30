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
  console.font = "solar24x32";
  boot.initrd.kernelModules = [ "panel-raydium-rm692e5" ];

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
    fairphone5 = {
      enable = true;
      modem.enable = true;
      usb-signaller.enable = true;
      fingerprint = {
        enable = true;
        fprintd = true;
      };
    };

  };
  programs.stoandl.enable = true;
  services.displayManager = {
    phrog.enable = true;
    dms-greeter.enable = lib.mkForce false;
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
