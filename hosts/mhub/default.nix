{ config, lib, modulesPath, options, secrets, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/agenix.nix
      ../../modules/docker.nix
      ../../modules/mediaserver.nix
      ../../modules/prometheus.nix
      ../../modules/services.nix
      #    ./flake.nix
      #    ./pgup.nix
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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYdgI7mui35jULsNMHkYHmpNWhccPFHFjrD89RgZMfmjeOX1FD1c2eu036V/UzVJxRveP9n3LsWt2BjTewDIbR49VOJSQUxvVN5eC1YsCdTZQiHEXePdhFRberWk5c/tdk1CimwqRfMzoZlmguATqtFx0RuuKkxhm0bp3NW/1CPFgvGK3IWukF1nJZjupsCcN9bmpLMwK171dYL3+WdjHPtjNkzUmLqZ8qYGvAnD8KC+H8a1AhAtHIqvK10Xgtot30QCieaBdQjUhzCfRLlyH7koOsPkYL8aMi6Oqn0LTfOl44fecEWadgF6C4f3i4UctWJmjh8q67zNvsDg5apo1wo8YMUg/5VkLHovn5nkp+OWtXKAt38dCht3iffpIMnayMx2peq+i5kCoCdJTIGZt1R/CniCtfrdaU0xIIjurhrV0VgTvVEztAdbo6jM/JEWknpbxn85kR1Gw1TkN11mqz8B4vl1ewZfFweC2l/LYniDiobY5kZD9wz0PoZx9v/3AKjK836t58V77qrueK/ltm8ar9x1K1QJCPrq4q3NCkeqdf/oH7icIOAoKxWNvqhZcYhf5s0sUo5RDEm+Pgz7VmM6vuhkN1DOQykzfP8uca6RFd2pW25fOXECiEftxurORLo2QO4WXavkvS1xccFtO/XAh02waFLsf64rXfrYZfbw== jhthorsen@cpan.org"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5nk6X1vCz724VJ9a7erW8KBRRU8daBTHpvq366yd6FY3D4CWcfBp1syUOsVfnRY+ZWoCGXuQwlJm7Hn/MTH+8ORaycOflkTkX4FN3QTp4Id9j+1JDqryRmqn4j/7j9Gh13NEXGi70QCI+XJdc+mG71BADLlcgUE+YGJvgVyNjkDc0h3kLVMZTU3cZ/DtewFStANDQcchZyHzfPUgOdGN3Zrh1rfod+SELCDcivo1MwJIvY90ugXKv9YuQVcQlGwG6djwM6Mxk5S0WJaR1D2hMQBfNkZHRQP/nBSCU6811Z6TOQDZc9YvB3YlN8VVD2TA2x4aAp9E8+XLSvzz1G8QbxnExqU3DnM74J+Fb1kREFMHT4teP3VC+DWzIzp2F6LSawdskl2LaUFmsqsGzpoBhToDTayTjA1jkgxu5kYHwBru6kpKV4tWM1FJnD+rT9IgQvhHif8+DO5S4E5P9hUKPJHs7e3rDDr2Li23aWAzse/tuga9GU0Ri5kPYei9smh80iyZRCVN6OB1PyagDnPRHoF2cDdCxut/bbsc8W3mdsVHlgPHOpMVeh2eDBdYnTDGGda322dJG78p88zwFeV91FZ8hWlWM3IjQB2Tqf+0664MjRcHXMOO/ysHAxOXh9y2HlIrebDiKTIGwKmeL0n1MxYHzPr0giGkfHkYf1fwAKw== jan.henning@thorsen.pm"
    ];
  };

}
