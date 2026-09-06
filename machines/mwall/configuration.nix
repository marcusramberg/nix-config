{
  imports = [
    ./network.nix
    ./dhcp.nix
    ./ddns.nix
    ./dns.nix
    ./firewall.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  programs.ccache.packageNames = [ "linux_7_2" ];

  # mtk_eth wants 3x2M contiguous for the PPE FOE tables at probe; the 32M
  # default pool is already spoken for and every boot logs cma alloc failed
  boot.kernelParams = [ "cma=128M" ];

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 4194304;
    "net.ipv4.igmp_max_memberships" = 1024;
    "net.ipv4.igmp_max_msf" = 10;
  };

  networking.useDHCP = false;
  powerManagement.cpuFreqGovernor = "schedutil";

  services = {
    # all five frame-engine irqs land on cpu0 otherwise
    irqbalance.enable = true;
    openssh.openFirewall = false;
    avahi = {
      enable = true;
      nssmdns4 = true;
      allowInterfaces = [
        "lan"
        "iot"
      ];
    };
    prometheus.exporters.node = {
      enable = true;
      openFirewall = false;
    };
    haproxy = {
      enable = true;
      config = ''
        frontend k3s-frontend
          bind 192.168.86.1:6443
          mode tcp
          option tcplog
          default_backend k3s-backend
        backend k3s-backend
          mode tcp
          option tcp-check
          balance roundrobin
          default-server inter 10s downinter 5s
          server mhub 192.168.86.20:6443 check
          server mstudio 192.168.86.21:6443 check
          server mbox 192.168.86.22:6443 check
      '';
    };
  };

  system.stateVersion = "26.05";
}
