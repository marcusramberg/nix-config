{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = true || (isNixOS && osConfig.services.xserver.enable);
  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${pkgs.flameshot}/bin/flameshot gui";
  cfg = {
    doubleScale = false;
  };

  fontName = "JetBrainsMono NFM";

  backgroundFile = "nordfox.jpg";
  accentColor = "blue";
  colorScheme = "prefer-dark";
in
{
  config = mkIf isDesktop {
    dconf.settings = lib.mkMerge [
      {
        # Gnome hotkeys
        "org/gnome/desktop/wm/keybindings" = {
          # Alt+F4 is very cumbersome
          close = [ "<Super>q" ];
          # Make it easy to maximize like you can fill left/right
          maximize = [ "<Super>Up" ];
          # Make it easy to resize undecorated windows
          begin-resize = [ "<Super>BackSpace" ];
        };

        # For keyboards that only have a start/stop button for music, like Logitech MX Keys Mini
        "org/gnome/settings-daemon/plugins/media-keys" = {
          next = [ "<Shift>AudioPlay" ];
        };

        # Full-screen with title/navigation bar
        "org/gnome/desktop/wm/keybindings" = {
          toggle-fullscreen = [ "<Shift>F11" ];
        };

        # Use 6 fixed workspaces instead of dynamic mode
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 6;
        };

        # Use alt for pinned apps
        "org/gnome/shell/keybindings" = {
          switch-to-application-1 = [ "<Alt>1" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-2 = [ "<Alt>2" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-3 = [ "<Alt>3" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-4 = [ "<Alt>4" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-5 = [ "<Alt>5" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-6 = [ "<Alt>6" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-7 = [ "<Alt>7" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-8 = [ "<Alt>8" ];
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-9 = [ "<Alt>9" ];
        };

        # Use super for workspaces
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = [ "<Super>1" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-2 = [ "<Super>2" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-3 = [ "<Super>3" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-4 = [ "<Super>4" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-5 = [ "<Super>5" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-6 = [ "<Super>6" ];
        };

        # Reserve slots for custom keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          ];
        };

        # Set ulauncher to Super+Space
        "org/gnome/desktop/wm/keybindings" = {
          switch-input-source = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Ulauncher";
          command = "ulauncher-toggle";
          binding = "<Super>space";
        };

        # Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
        # NOTE(m): Thanks to viniciussalvati (https://github.com/flameshot-org/flameshot/issues/3365#issuecomment-1868580715)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Flameshot";
          command = "${flameshot-gui}/bin/flameshot-gui";
          binding = "<Control>Print";
        };

        # Start a new wezterm window (rather than just switch to the already open one)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          name = "Wezterm";
          command = "wezterm";
          binding = "<Shift><Alt>2";
        };

        # Start a new Chrome window (rather than just switch to the already open one)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          name = "New Floorp";
          command = "flatpak run one.ablaze.floorp";
          binding = "<Shift><Alt>1";
        };

        "org/gnome/desktop/interface" = {
          monospace-font-name = "${fontName} 10";
          color-scheme = colorScheme;
          cursor-theme = "Yaru";
          # gtk-theme = "Yaru-${accentColor}-dark";
          icon-theme = "Yaru-${accentColor}";
          enable-hot-corners = false;
          show-battery-percentage = true;
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "google-chrome.desktop"
            "WezTerm.desktop"
            "code.desktop"
            "Telegram-Destop.desktop"
            "typora.desktop"
            "pinta.desktop"
            "com.github.xournalpp.xournalpp.desktop"
            "org.gnome.Settings.desktop"
            "org.gnome.Nautilus.desktop"
          ];
          disable-user-extensions = false;
          enabled-extensions = [
            pkgs.gnomeExtensions.blur-my-shell.extensionUuid
            pkgs.gnomeExtensions.custom-accent-colors.extensionUuid
            pkgs.gnomeExtensions.just-perfection.extensionUuid
            pkgs.gnomeExtensions.space-bar.extensionUuid
            pkgs.gnomeExtensions.tactile.extensionUuid
            pkgs.gnomeExtensions.undecorate.extensionUuid
            pkgs.gnomeExtensions.user-themes.extensionUuid
          ];
        };

        "org/gnome/mutter" = {
          experimental-features = lib.optionals (!cfg.doubleScale) [ "scale-monitor-framebuffer" ];
          edge-tiling = true;
          center-new-windows = true;
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${../wallpaper/${backgroundFile}}";
          picture-uri-dark = "file://${../wallpaper/${backgroundFile}}";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${../wallpaper/${backgroundFile}}";
          picture-uri-dark = "file://${../wallpaper/${backgroundFile}}";
          picture-options = "zoom";
        };

        # Emoji's
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "compose:caps" ];
        };

        # Configure Tactile
        "org/gnome/shell/extensions/tactile" = {
          col-0 = 1;
          col-1 = 2;
          col-2 = 1;
          col-3 = 0;
          row-0 = 1;
          row-1 = 1;
          gap-size = 32;
        };

        # Configure Just perfection
        "org/gnome/shell/extensions/just-perfection" = {
          animation = 2;
          dash-app-running = true;
          workspace = true;
          workspace-popup = false;
        };

        # Configure Blur my shell
        "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
          blur = false;
        };
        "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
          blur = false;
        };
        "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
          blur = false;
        };
        "org/gnome/shell/extensions/blur-my-shell/window-list" = {
          blur = false;
        };
        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          brightness = 0.6;
          sigma = 30;
          pipeline = "pipeline_default";
        };
        "org/gnome/shell/extensions/blur-my-shell/overview" = {
          blur = true;
          pipeline = "pipeline_default";
        };
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
          blur = true;
          brightness = 0.6;
          sigma = 30;
          static-blur = true;
          style-dash-to-dock = 0;
        };

        # Configure Space Bar
        "org/gnome/shell/extensions/space-bar/behavior" = {
          smart-workspace-names = false;
        };
        "org/gnome/shell/extensions/space-bar/shortcuts" = {
          enable-activate-workspace-shortcuts = false;
          enable-move-to-workspace-shortcuts = true;
          open-menu = [ ];
        };

        # Configure custom accent colors
        "org/gnome/shell/extensions/custom-accent-colors" = {
          accent-color = accentColor;
          theme-flatpak = true;
          theme-gtk3 = true;
          theme-shell = true;
        };
        "org/gnome/shell/extensions/user-theme" = {
          name = "Custom-Accent-Colors";
        };
      }

      (lib.mkIf cfg.doubleScale {
        "org/gnome/desktop/interface" = {
          text-scaling-factor = 0.8;
          cursor-size = 16;
        };
      })
    ];

    # Emoji's
    home = {
      file = {
        ".XCompose" = {
          text = ''
            include "%L"

            <Multi_key> <m> <s> : "😀" # smile
            <Multi_key> <m> <c> : "😂" # cry
            <Multi_key> <m> <l> : "😍" # love
            <Multi_key> <m> <v> : "✌️"  # victory
            <Multi_key> <m> <h> : "❤️"  # heart
            <Multi_key> <m> <y> : "👍" # yes
            <Multi_key> <m> <n> : "👎" # no
            <Multi_key> <m> <f> : "🖕" # fuck
            <Multi_key> <m> <w> : "🤞" # wish
            <Multi_key> <m> <r> : "🤘" # rock
            <Multi_key> <m> <k> : "😘" # kiss
            <Multi_key> <m> <e> : "🙄" # eyeroll
            <Multi_key> <m> <d> : "🤤" # droll
            <Multi_key> <m> <m> : "💰" # money
            <Multi_key> <m> <x> : "🎉" # xellebrate
            <Multi_key> <m> <1> : "💯" # 100%
            <Multi_key> <m> <t> : "🥂" # toast
          '';
          force = true;
        };
      };
      packages = with pkgs; [
        gnome.gnome-tweaks
        gnomeExtensions.blur-my-shell
        gnomeExtensions.custom-accent-colors
        gnomeExtensions.just-perfection
        gnomeExtensions.space-bar
        gnomeExtensions.tactile
        gnomeExtensions.undecorate
        gnomeExtensions.user-themes
        ulauncher
        yaru-theme
      ];
      # Ulauncher
      file.".config/autostart/ulauncher.desktop" = {
        text = ''
          [Desktop Entry]
          Name=Ulauncher
          Comment=Application launcher for Linux
          GenericName=Launcher
          Categories=GNOME;GTK;Utility;
          TryExec=${pkgs.ulauncher}/bin/ulauncher
          Exec=env GDK_BACKEND=x11 ${pkgs.ulauncher}/bin/ulauncher --hide-window --hide-window
          Icon=ulauncher
          Terminal=false
          Type=Application
          X-GNOME-Autostart-enabled=true
        '';
        force = true; # overwrite existing
      };
      file.".config/ulauncher/settings.json" = {
        text = ''
          {
            "clear-previous-query": true,
            "disable-desktop-filters": false,
            "grab-mouse-pointer": false,
            "hotkey-show-app": "null",
            "render-on-screen": "mouse-pointer-monitor",
            "show-indicator-icon": true,
            "show-recent-apps": "0",
            "terminal-command": "",
            "theme-name": "dark"
          }
        '';
        force = true;
      };
    };
  };
}
