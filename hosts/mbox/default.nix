_:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/keyboardmap.nix
    ../../modules/pipewire.nix
  ];

  networking = {
    extraHosts = ''
      10.211.55.2 mbook
      0.0.0.0 vg.no www.vg.no
    '';
    hostName = "mbox";
    networkmanager.enable = true;
  };

  # Bootloader.
  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile
    initrd = {
      secrets = { "/crypto_keyfile.bin" = null; };
      # Enable swap on luks
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".device =
        "/dev/disk/by-uuid/0050060b-f9cb-4697-8934-aef2f5ad0e2a";
      luks.devices."luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a".keyFile =
        "/crypto_keyfile.bin";
    };
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };

  services = {
    flatpak.enable = true;
    xserver.dpi = 144;
    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
  };

  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
  };
}
