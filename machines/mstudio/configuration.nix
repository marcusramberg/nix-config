{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options macsmc_hwmon fan_control=1
    '';
    postBootCommands = ''
      echo 1100 > /sys/class/hwmon/hwmon?/fan1_target
      echo 1100 > /sys/class/hwmon/hwmon?/fan2_target
    '';
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
    asahi-nvram
    asahi-btsync
    asahi-wifisync
    box64
    freecad-wayland
    prusa-slicer
  ];

  fileSystems = {
    "/space" = {
      device = "mspace:/volume1/space";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
      ];
    };
    "/homes" = {
      device = "mspace:/volume1/homes";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
      ];
    };
  };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
    };
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
  };

  networking = {
    networkmanager.enable = false;
    firewall.trustedInterfaces = [
      "incusbr0"
    ];
  };

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };
  nixpkgs.config.allowUnsupportedSystem = true;
  # Enable the X11 windowing system.
  profiles = {
    autoupgrade.enable = true;
    dockerHost.enable = true;
    desktop.niri.enable = true;
    k3s = {
      enable = true;
      staticIP = {
        enable = true;
        ip = "192.168.86.21";
      };
    };
  };
  programs = {
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;

    };
    # streamcontroller.enable = true;
    virt-manager.enable = true;
  };

  services = {
    blueman.enable = true;
    displayManager.sddm.enableHidpi = true;
    k3s.serverAddr = "https://192.168.86.1:6443";
    libinput.enable = true;
    ollama.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig.pipewire-pulse."context.exec" = [
        {
          path = "pactl";
          args = "load-module module-switch-on-connect";
        }
      ];
      wireplumber.enable = true;
    };
    rustdesk-server = {
      enable = true;
      relay.enable = true;
      signal.relayHosts = [ "mstudio.pig-crested.ts.net" ];
      openFirewall = true;
    };
    xserver.dpi = 140;
  };
  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  users.users = {
    arne = {
      description = "Arne";
      isNormalUser = true;
      uid = 1002;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkHOi39HCigHCOneTKIiY+C809n6d3sNHd3hoy2Uq21"
      ];
    };
  };
  virtualisation = {
    incus.enable = true;
    incus.ui.enable = true;
    libvirtd.enable = true;
  };
  zramSwap.enable = true;
}
