{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "desktop environment with plasma and catppuccin theme";
    niri.enable = lib.mkEnableOption "enable niri environment";
  };

  config = lib.mkIf cfg.enable {

    # Enable plymouth
    boot = {
      initrd.systemd.enable = true; # This is needed to show the plymouth login screen to unlock luks
      plymouth = {
        enable = true;
        theme = "catppuccin-mocha";
        themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      };
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
    };

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        kwin-x11
        kate
        ktexteditor
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        (catppuccin.override {
          variant = "mocha";
          accent = "lavender";
          themeList = [
            "bat"
            "btop"
            "element"
            "k9s"
            "lazygit"
            "waybar"
          ];
        })
        (catppuccin-gtk.override {
          variant = "mocha";
          accents = [
            "blue"
            "teal"
            "lavender"
          ];

        })
        (catppuccin-kde.override {
          flavour = [ "mocha" ];
          winDecStyles = [
            "classic"
          ];
          accents = [
            "blue"
            "teal"
            "lavender"
          ];

        })
        catppuccin-cursors.mochaLavender
        (catppuccin-kvantum.override {
          variant = "mocha";
          accent = "lavender";
        })
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        })
        (catppuccin-sddm.override {
          flavor = "mocha";
          font = "JetBrainsMono Nerd Font Propo";
          fontSize = "9";
        })
        ghostty
        hunspell
        hunspellDicts.en_US
        kdePackages.kaccounts-providers
        kdePackages.karousel
        kdePackages.kio-gdrive
        webcord-vencord
      ];
    };

    profiles.myfonts.enable = true;
    programs = {
      chromium.enable = true;
      firefox = {
        enable = true;
        nativeMessagingHosts.packages =
          with pkgs;
          [ tridactyl-native ]
          ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [ fx-cast-bridge ];
      };
      kdeconnect.enable = true;
      niri = lib.mkIf cfg.niri.enable {
        enable = true;
        package = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.niri;
      };
      dankMaterialShell = {
        enable = true;
        systemd.enable = true;
        quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      ssh.enableAskPassword = true;
    };

    qt = {
      style = "breeze";
      platformTheme = "kde";
    };

    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = false;
      };
      dbus.packages = [ pkgs.dconf ];
      displayManager.sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        theme = "catppuccin-mocha-mauve";
        settings.General.InputMethod = "";
      };
      displayManager.defaultSession = lib.mkForce (if cfg.niri.enable then "niri" else "plasma");
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      orca.enable = false;
      xserver = {
        enable = false;
        xkb = {
          layout = "us";
          options = "eurosign:e";
          variant = "mac";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    xdg.portal.xdgOpenUsePortal = true;
  };
}
