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

  oneplus-fajita = {
    enable = true;
    user = "marcus";
  };

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
  };
}
