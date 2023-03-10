{ pkgs, ... }:

{
  services = {
    dbus.packages = [ pkgs.dconf ];

    # Always be sshing
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;

    picom = {
      enable = true;
      activeOpacity = 0.95;
    };

    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      xkbOptions = "eurosign:e";
      displayManager.sddm.enable = true;
      displayManager.defaultSession = "xfce";
      desktopManager = {
        xterm.enable = true;
        plasma5.enable = true;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;
    };
    xrdp.enable = true;
    tailscale.enable = true;
    keybase.enable = true;
    #fail2ban.enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
