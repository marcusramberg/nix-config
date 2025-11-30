{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
  };
  services.scx.enable = true; # by default uses scx_rustland scheduler

  environment.systemPackages = with pkgs; [
    firedragon-catppuccin-bin
  ];
  hardware = {
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

}
