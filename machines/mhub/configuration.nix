{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = false;
      device = "/dev/sda";
    };
    kernelParams = [ "pcie_aspm=off" ];
    kernel.sysctl = {
      "net.core.rmem_max" = 4194304;
      "net.ipv4.igmp_max_memberships" = 1024;
      "net.ipv4.igmp_max_msf" = 10;
    };
  };

  fileSystems."/space" = {
    device = "mspace.lan:/volume1/space";
    fsType = "nfs4";
    options = [
      "nfsvers=4.1"
      "soft"
      "x-systemd.automount"
      "noauto"
    ];
  };

  networking = {
    enableIPv6 = false;
  };

  profiles = {
    mediaserver.enable = true;
    hass.enable = true;
    prometheus-server.enable = true;
    caddy = {
      enable = true;
      configFile = ../../config/Caddyfile.mhub;
    };
    k3s = {
      enable = true;
      staticIP = {
        enable = true;
        ip = "192.168.86.20";
      };
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    borgbackup.jobs = {
      varBackup = {
        paths = "/var";
        exclude = [
          "/var/cache"
          "/var/lib/containers"
          "/var/log"
          "/var/lib/plex/Library/Application Support/Plex Media Server/Plug-in Support/Databases/"
          "/var/lib/prometheus2/data/"
        ];
        repo = "/space/mhub/var";
        doInit = true;
        encryption = {
          mode = "repokey";
          passCommand = "cat ${config.age.secrets.borgbackup.path}";
        };
        compression = "auto,lzma";
        startAt = "weekly";
      };
    };
    k3s = {
      serverAddr = "https://192.168.86.1:6443";
    };
    printing.enable = true;
  };

  systemd.services.caddy.serviceConfig.AmbientCapabilities = "cap_net_bind_service";

  users.users = {
    arne = {
      description = "Arne";
      isNormalUser = true;
      uid = 1002;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8/0kSssHk6Bzd5Vw43fHwBk57BOPSa3GrvEe+v+CTogJMGWzXwyXNcK/ogSt3R/xzR97afrUKdZB6enHLNhiHVNZ0ymEDaNXGJKKJwIcLPiiNZ0soJRoLr06hw/7B9FDAZIreRED7mmCNW3T0ikqjuk0zomc/r2OsnalV4Xhh9+pDxBv/FQAro1dCUe+EP5IKD7I8wUvZillFqdW8VNPL7XML3WfNhxPJ070U+EMnsW1hMS/eaeYzi/jgpAyEE/ViKSyCa4l+RDLezjfnnDAW8TNRlaL+wPPMp4chBmIIx97rAV+WqYg/acryppwe//CW9wHDK7vK3USYpQgZ0PKtjOY1qK7s44nkgwzKZHy2cXDDzrIlILRYESz7JELfbBk8yVT8B2ziFiIeUav4To9DvyYG4QqiSbOUGvt5tnqpoWcu2bnzV6rniOVmQXq/la7ORYy1Aw9nqRSlyYMo632EQh7rJEGwPOf1RWwORaWdbE3pF0B6B8eHJ3QOOt0+6aM= arne@aBook.local"
      ];
    };
    jhthorsen = {
      isNormalUser = true;
      description = "Batman";
      uid = 1001;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYdgI7mui35jULsNMHkYHmpNWhccPFHFjrD89RgZMfmjeOX1FD1c2eu036V/UzVJxRveP9n3LsWt2BjTewDIbR49VOJSQUxvVN5eC1YsCdTZQiHEXePdhFRberWk5c/tdk1CimwqRfMzoZlmguATqtFx0RuuKkxhm0bp3NW/1CPFgvGK3IWukF1nJZjupsCcN9bmpLMwK171dYL3+WdjHPtjNkzUmLqZ8qYGvAnD8KC+H8a1AhAtHIqvK10Xgtot30QCieaBdQjUhzCfRLlyH7koOsPkYL8aMi6Oqn0LTfOl44fecEWadgF6C4f3i4UctWJmjh8q67zNvsDg5apo1wo8YMUg/5VkLHovn5nkp+OWtXKAt38dCht3iffpIMnayMx2peq+i5kCoCdJTIGZt1R/CniCtfrdaU0xIIjurhrV0VgTvVEztAdbo6jM/JEWknpbxn85kR1Gw1TkN11mqz8B4vl1ewZfFweC2l/LYniDiobY5kZD9wz0PoZx9v/3AKjK836t58V77qrueK/ltm8ar9x1K1QJCPrq4q3NCkeqdf/oH7icIOAoKxWNvqhZcYhf5s0sUo5RDEm+Pgz7VmM6vuhkN1DOQykzfP8uca6RFd2pW25fOXECiEftxurORLo2QO4WXavkvS1xccFtO/XAh02waFLsf64rXfrYZfbw== jhthorsen@cpan.org"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5nk6X1vCz724VJ9a7erW8KBRRU8daBTHpvq366yd6FY3D4CWcfBp1syUOsVfnRY+ZWoCGXuQwlJm7Hn/MTH+8ORaycOflkTkX4FN3QTp4Id9j+1JDqryRmqn4j/7j9Gh13NEXGi70QCI+XJdc+mG71BADLlcgUE+YGJvgVyNjkDc0h3kLVMZTU3cZ/DtewFStANDQcchZyHzfPUgOdGN3Zrh1rfod+SELCDcivo1MwJIvY90ugXKv9YuQVcQlGwG6djwM6Mxk5S0WJaR1D2hMQBfNkZHRQP/nBSCU6811Z6TOQDZc9YvB3YlN8VVD2TA2x4aAp9E8+XLSvzz1G8QbxnExqU3DnM74J+Fb1kREFMHT4teP3VC+DWzIzp2F6LSawdskl2LaUFmsqsGzpoBhToDTayTjA1jkgxu5kYHwBru6kpKV4tWM1FJnD+rT9IgQvhHif8+DO5S4E5P9hUKPJHs7e3rDDr2Li23aWAzse/tuga9GU0Ri5kPYei9smh80iyZRCVN6OB1PyagDnPRHoF2cDdCxut/bbsc8W3mdsVHlgPHOpMVeh2eDBdYnTDGGda322dJG78p88zwFeV91FZ8hWlWM3IjQB2Tqf+0664MjRcHXMOO/ysHAxOXh9y2HlIrebDiKTIGwKmeL0n1MxYHzPr0giGkfHkYf1fwAKw== jan.henning@thorsen.pm"
      ];
    };
  };
}
