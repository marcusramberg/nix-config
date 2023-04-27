{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    noto-fonts-emoji
    liberation_ttf
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })

  ];

  qt.platformTheme = "gtk";

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
      displayManager.lightdm.enable = true;
      displayManager.lightdm.greeters.gtk.enable = true;
      displayManager.lightdm.greeters.gtk.theme.name = "Nordic";

      displayManager.defaultSession = "xfce+nimdow";
      desktopManager = {
        plasma5.enable = true;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.awesome.enable = true;
      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;
      windowManager.nimdow.enable = true;
    };
    # xrdp.enable = true;
    tailscale.enable = true;
    keybase.enable = true;
    #fail2ban.enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
