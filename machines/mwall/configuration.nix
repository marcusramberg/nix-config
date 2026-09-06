{
  imports = [
    ./network.nix
    ./dhcp.nix
    ./ddns.nix
    ./dns.nix
    ./firewall.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # bpi module exports hardware.nix only, so the ccache overlay from its
  # configuration.nix is not inherited; must match kernel.nix's base package
  programs.ccache.packageNames = [ "linux_7_2" ];

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 4194304;
    "net.ipv4.igmp_max_memberships" = 1024;
    "net.ipv4.igmp_max_msf" = 10;
  };

  networking.useDHCP = false;
  powerManagement.cpuFreqGovernor = "ondemand";

  services = {
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
