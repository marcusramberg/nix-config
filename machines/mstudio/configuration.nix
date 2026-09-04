{ pkgs, lib, ... }:

let
  music-assistant-companion = pkgs.callPackage ../../packages/music-assistant-companion { };
in
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
    music-assistant-companion
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
      enable = true;
    };
    bluetooth.enable = true;
    keyboard.dual-caps = {
      enable = true;
      swapAlt = {
        enable = true;
        devices = [ "/dev/input/by-id/logiwave-event-kbd" ];
      };
    };
  };

  networking = {
    networkmanager.enable = false;
    firewall.allowedTCPPorts = [ 6667 ];
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
    ccache.enable = true;
    dockerHost.enable = true;
    incus.enable = true;
    k3s = {
      enable = true;
      serverAddr = "https://192.168.86.1:6443";
      staticIP = {
        enable = true;
        ip = "192.168.86.21";
      };
    };
  };
  programs = {
    # shared ccache for ARM kernel/device builds (see sandbox-paths above)
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;

    };
    # streamcontroller.enable = true;
    virt-manager.enable = true;
    wayvnc.enable = true;
  };

  services = {
    ergochat = {
      enable = true;
      settings = {
        logging = [
          {
            level = "debug";
            type = "* -userinput -useroutput";
            method = "stderr";
          }
        ];

      };
    };
    ratbagd.enable = true;

    blueman.enable = true;
    displayManager.sddm.enableHidpi = true;
    libinput.enable = true;
    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32400";
      };
    };
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
    prometheus.exporters.node.enable = true;
    rustdesk-server = {
      enable = true;
      relay.enable = true;
      signal.relayHosts = [ "mstudio.pig-crested.ts.net" ];
      openFirewall = true;
    };
    xserver = {
      dpi = 140;
      xkb.variant = lib.mkForce "mac-iso";
    };
  };
  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  # Work around a Linux 7.0 UDP-GSO regression that craters tailscale TX
  # throughput on end0 (outbound bulk transfers collapse to ~150 kB/s while
  # raw TCP / receive stay fast). Disabling UDP segmentation + GSO on the
  # physical NIC restores full speed. See tailscale/tailscale#19777.
  #
  # This is an interim hack. Tailscale ships a proper client-side workaround
  # (keeps UDP GSO, no offload disabling) from v1.99.110 / stable v1.100, and
  # the kernel bug itself is fixed in 7.1.5. mstudio is on tailscale 1.98.2.
  # DROP THIS once any of: tailscale >= 1.100 (or >= 1.99.110), kernel >= 7.1.5,
  # or the two fix commits (torvalds/linux@78effd8, @5f17ae0f595a) are backported.
  systemd.services.fix-end0-udp-gso = {
    description = "Disable broken UDP GSO on end0 (tailscale TX throughput, kernel 7.0 regression)";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-subsystem-net-devices-end0.device" ];
    bindsTo = [ "sys-subsystem-net-devices-end0.device" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K end0 tx-udp-segmentation off generic-segmentation-offload off";
    };
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
    jomar = {
      description = "Jomar";
      isNormalUser = true;
      uid = 1003;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkWRFjzmUk/FJR1g3Ck5jRmRUctAeS/remDgAWZPFWP jomarj@gmail.com"
      ];
    };
  };
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
  };
  zramSwap.enable = true;
}
