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
    interception-tools = let
      # Map caps lock to:
      # - ESC when tapped
      # - LCTRL when held
      dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" ''
        MAPPINGS:
          # CAPS (tap) -> ESC, CAPS (hold) -> LCTRL
          - KEY: KEY_CAPSLOCK
            TAP: KEY_ESC
            HOLD: KEY_LEFTCTRL

          # Swap LALT with LCTRL
          - KEY: KEY_LEFTALT
            TAP: KEY_LEFTCTRL
            HOLD: KEY_LEFTCTRL
            HOLD_START: BEFORE_CONSUME

          # Swap LCTRL with LALT
          - KEY: KEY_LEFTCTRL
            TAP: KEY_LEFTALT
            HOLD: KEY_LEFTALT
            HOLD_START: BEFORE_CONSUME
      '';
    in {
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dualFunctionKeysConfig} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            LINK: .*-event-kbd
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [ 3389 ];

}
