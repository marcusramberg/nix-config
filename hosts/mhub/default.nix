{ config, lib, modulesPath, options, secrets, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/docker.nix
      ../../modules/mediaserver.nix
      ../../modules/minecraft.nix
      ../../modules/prometheus.nix
      ../../modules/services.nix
      #    ./host.nix
      #    ./flake.nix
      #    ./pgup.nix
      #    ../k3s.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [ "pcie_aspm=off" ];
  boot.kernel.sysctl."net.ipv4.igmp_max_memberships" = 1024;
  boot.kernel.sysctl."net.ipv4.igmp_max_msf" = 10;
  boot.kernel.sysctl."net.core.rmem_max" = 4194304;
  fileSystems."/space" = {
    device = "192.168.86.211:/volume1/space";
    fsType = "nfs4";
    options = [ "nfsvers=4.1" "soft" ];
  };
  networking.hostName = "mhub"; # Define your hostname.
  networking.enableIPv6 = false;
  users.users.jhthorsen = {
    isNormalUser = true;
    description = "Batman";
    uid = 1001;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYdgI7mui35jULsNMHkYHmpNWhccPFHFjrD89RgZMfmjeOX1FD1c2eu036V/UzVJxRveP9n3LsWt2BjTewDIbR49VOJSQUxvVN5eC1YsCdTZQiHEXePdhFRberWk5c/tdk1CimwqRfMzoZlmguATqtFx0RuuKkxhm0bp3NW/1CPFgvGK3IWukF1nJZjupsCcN9bmpLMwK171dYL3+WdjHPtjNkzUmLqZ8qYGvAnD8KC+H8a1AhAtHIqvK10Xgtot30QCieaBdQjUhzCfRLlyH7koOsPkYL8aMi6Oqn0LTfOl44fecEWadgF6C4f3i4UctWJmjh8q67zNvsDg5apo1wo8YMUg/5VkLHovn5nkp+OWtXKAt38dCht3iffpIMnayMx2peq+i5kCoCdJTIGZt1R/CniCtfrdaU0xIIjurhrV0VgTvVEztAdbo6jM/JEWknpbxn85kR1Gw1TkN11mqz8B4vl1ewZfFweC2l/LYniDiobY5kZD9wz0PoZx9v/3AKjK836t58V77qrueK/ltm8ar9x1K1QJCPrq4q3NCkeqdf/oH7icIOAoKxWNvqhZcYhf5s0sUo5RDEm+Pgz7VmM6vuhkN1DOQykzfP8uca6RFd2pW25fOXECiEftxurORLo2QO4WXavkvS1xccFtO/XAh02waFLsf64rXfrYZfbw== jhthorsen@cpan.org" ];
  };

}
