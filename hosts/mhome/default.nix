_:

{
  boot = {
    kernelParams = [ "pcie_aspm=off" ];
    loader.systemd-boot.enable = true;
  };
  loader.grub.device = "/dev/sda";
  networking.hostName = "mhome"; # Define your hostname.
}
