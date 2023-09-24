{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/pipewire.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    extraModprobeConfig = ''
      options snd_hda_intel index=0 model=intel-mac-auto id=PCM
      options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
      options snd_hda_intel model=mbp101
    '';
  };

  hardware = {
    bluetooth.enable = false;
    keyboard.dual-caps.enable = true;
    facetimehd.enable = true;
    opengl.extraPackages = [ pkgs.vaapiIntel ];
  };
  networking = {
    hostName = "mtop";
    enableIPv6 = false;
    networkmanager.enable = true;
  };

  powerManagement.enable = true;

  profiles = {
    laptop.enable = true;
    nimdow.enable = true;
  };

  programs.nm-applet.enable = true;

  services = {
    flatpak.enable = true;
    input-remapper.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
    mbpfan.enable = true;
    xserver.dpi = 220;
  };

}
