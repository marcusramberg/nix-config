{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf".device =
      "/dev/disk/by-uuid/1e71b8af-cf9d-4e45-b36f-4ac377a6e3cf";
  };

  environment.systemPackages = with pkgs; [
    spotify
    ssh-tpm-agent
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    keyboard.dual-caps = {
      enable = true;
      swapAlt = {
        enable = true;
        devices = [
          "/dev/input/by-id/usb-SDINNOVATION_Gaming_Keyboard_003123456789-event-kbd"
          "/dev/input/by-path/pci-0000:00:14.0-usb-0:13.2:1.1-event-kbd"
          "/dev/input/by-id/logitech.input-event-kbd"
        ];
      };
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "mdesk";
  };

  profiles = {
    ccache.enable = true;
    incus.enable = true;
    work.enable = true;
  };

  services.xserver.xkb.variant = lib.mkForce "mac-iso";

  # During work hours (08:00-20:00 on weekdays) keep the machine quiet by
  # disabling turbo and capping performance. Outside those hours (evenings,
  # nights and weekends) run at full performance so nightly builds are fast.
  systemd.services.cpu-perf-mode = {
    description = "Apply quiet/performance CPU mode based on time of day";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # Day of week: 1=Mon ... 7=Sun; hour as an integer (08-19 == work hours)
      dow=$(${pkgs.coreutils}/bin/date +%u)
      hour=$(${pkgs.coreutils}/bin/date +%-H)
      if [ "$dow" -le 5 ] && [ "$hour" -ge 8 ] && [ "$hour" -lt 20 ]; then
        # Quiet mode
        echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
        echo 75 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
        echo 10 > /sys/class/thermal/cooling_device38/cur_state
      else
        # Full performance mode
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
        echo 0 > /sys/class/thermal/cooling_device38/cur_state
      fi
    '';
  };

  systemd.timers.cpu-perf-mode = {
    description = "Switch CPU mode at the work-hour boundaries";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Re-evaluate at the boundaries (08:00 and 20:00) and hourly as a safety
      # net so a resumed/booted machine settles into the right mode quickly.
      OnCalendar = [
        "*-*-* 08:00:00"
        "*-*-* 20:00:00"
        "hourly"
      ];
      Persistent = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
    podman.enable = true;
  };

}
