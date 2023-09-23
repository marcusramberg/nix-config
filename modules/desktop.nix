{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.profiles.nimdow;
in {
  options.profiles.nimdow = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Nimdow desktop user environment";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        copyq
        discord
        element-desktop
        feh
        neovide
        nitrogen
        obsidian
        pavucontrol
        picom
        nordic
        rofi
        telegram-desktop
        vivaldi
        volumeicon
        xarchiver
        xclip
      ] ++ lib.optionals (pkgs.system == "x86_64-linux")
      [ pkgs.vivaldi-ffmpeg-codecs ];

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
        windowManager.nimdow.enable = true;
      };
      xrdp.enable = true;
    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
    xdg.mime.defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };
    environment.sessionVariables.DEFAULT_BROWSER =
      "${pkgs.vivaldi}/bin/vivaldi";
  };
}
