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
    # kernelPackages = pkgs.linuxPackages_cachyos;
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
  services.scx.enable = true; # by default uses scx_rustland scheduler

  environment.systemPackages = with pkgs; [
    spotify
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
    networkmanager.enable = true;
  };

  powerManagement.enable = true;

  profiles.limine.enable = true;

  services = {
    # displayManager.autoLogin.enable = true;
    # displayManager.autoLogin.user = "marcus";
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
