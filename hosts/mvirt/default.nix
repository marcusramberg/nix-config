_:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/desktop.nix
    ../../modules/pipewire.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth.enable = false;
    facetimehd.enable = true;
  };
  networking = {
    hostName = "mvirt";
    enableIPv6 = false;
    networkmanager.enable = true;
  };

  services = {
    flatpak.enable = true;
    input-remapper.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
  };
}
