{ pkgs, ... }:

{
  imports = [
    ../../modules/pipewire.nix
  ];
  boot = {
    extraModprobeConfig = ''
      options snd_hda_intel index=0 model=intel-mac-auto id=PCM
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
    '';
    # Linux 7.3 dropped strncpy(); facetimehd still calls it once.
    kernelPackages = pkgs.linuxPackages_latest.extend (
      _: prev: {
        facetimehd = prev.facetimehd.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace fthd_v4l2.c --replace-fail strncpy strscpy
          '';
        });
      }
    );
    kernelParams = [
      "acpi_backlight=native"
    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8196;
    }
  ];
  environment.systemPackages = with pkgs; [
    spotify
  ];
  hardware = {
    amdgpu.legacySupport.enable = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
    facetimehd.enable = true;
    graphics = {
      enable = true;
    };
  };
  networking = {
    hostName = "mtop";
    networkmanager.enable = true;
  };

  powerManagement.enable = true;
  programs.fjordxy.lock.lockAfter = 900;

  profiles.limine.enable = true;

  services = {
    # displayManager.autoLogin.enable = true;
    # displayManager.autoLogin.user = "marcus";
    input-remapper.enable = true;
    mbpfan = {
      enable = true;
      aggressive = false;
    };
    scx-loader = {
      enable = true;
      config.default_sched = "scx_lavd";
    };
    xserver.videoDrivers = [ "modesetting" ];
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

  };

  systemd.services.brightness-init = {
    description = "brightness init";
    wantedBy = [ "graphical.target" ];
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
    };
    script = ''
      sleep 5
      echo 150 > /sys/class/backlight/amdgpu_bl1/brightness
    '';
  };

}
