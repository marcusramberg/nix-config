{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ../../modules/pipewire.nix
  ];
  boot = {
    loader.efi.efiSysMountPoint = "/boot/efi";
    extraModprobeConfig = ''
      options snd_hda_intel index=0 model=intel-mac-auto id=PCM
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
    '';
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [
      "acpi_backlight=native"
    ];
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/86952286-ffab-4b03-8a78-0c21099588bd";
      fsType = "ext4";
    };
    "/home/marcus" = {
      device = "/dev/disk/by-uuid/4d79d071-7bee-4cf0-85fa-01f313cb9eab";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8196;
    }
  ];
  services.scx.enable = true; # by default uses scx_rustland scheduler

  environment.systemPackages = with pkgs; [
    firedragon-catppuccin-bin
  ];
  hardware = {
    amdgpu.legacySupport.enable = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = false;
    keyboard.dual-caps.enable = true;
    facetimehd.enable = true;
    graphics = {
      enable = true;
    };
  };
  networking = {
    hostName = "mtop";
    enableIPv6 = false;
    networkmanager.enable = true;
  };

  powerManagement.enable = true;

  profiles.limine.enable = true;

  services = {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "marcus";
    input-remapper.enable = true;
    mbpfan = {
      enable = true;
      aggressive = false;
    };
    xserver.videoDrivers = [ "modesetting" ];

  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  systemd.services.brightness-init = {
    description = "brightness init";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
    };
    script = ''
      echo 150 > /sys/class/backlight/amdgpu_bl1/brightness
    '';
  };

}
