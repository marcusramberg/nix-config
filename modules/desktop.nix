{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs;
    [
      copyq
      element-desktop
      feh
      neovide
      nitrogen
      obsidian
      pavucontrol
      picom
      rofi
      telegram-desktop
      vivaldi
      volumeicon
      xclip
    ] ++ lib.optionals (pkgs.system == "x86_64-linux")
    [ pkgs.vivaldi-ffmpeg-codecs ];
  programs.hyprland.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    liberation_ttf
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "Hack" ]; })

  ];

  qt.platformTheme = "gtk";

  services = {
    dbus.packages = [ pkgs.dconf ];

    # Always be sshing
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;

    picom = {
      enable = true;
      activeOpacity = 1;
      vSync = true;
      backend = "glx";
    };

    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      xkbOptions = "eurosign:e";
      xkbVariant = "mac";
      displayManager = {
        defaultSession = "xfce+nimdow";
        lightdm = {
          greeters.gtk.enable = true;
          greeters.gtk.theme.name = "Nordic";
          enable = true;
        };
      };

      desktopManager = {
        plasma5.enable = true;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      # windowManager.awesome.enable = true;
      # windowManager.i3.enable = true;
      # windowManager.i3.package = pkgs.i3-gaps;
      windowManager.nimdow.enable = true;
    };
    # xrdp.enable = true;
    #fail2ban.enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 3389 ];
  xdg.mime.defaultApplications = {
    "text/html" = "vivaldi-stable.desktop";
    "x-scheme-handler/http" = "vivaldi-stable.desktop";
    "x-scheme-handler/https" = "vivaldi-stable.desktop";
    "x-scheme-handler/about" = "vivaldi-stable.desktop";
    "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
  };
  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.vivaldi}/bin/vivaldi";
}
