{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = pkgs.stdenv.isLinux && (isNixOS && osConfig.services.desktopManager.plasma6.enable);
in
{
  config = lib.mkIf isDesktop {
    home.packages = with pkgs; [
      element-desktop
      geeqie
      neovide
      obsidian
      showmethekey
      signal-desktop
      spotify-player
      telegram-desktop
      kdePackages.tokodon
      vivaldi
      vivaldi-ffmpeg-codecs
      vlc
      wl-clipboard
      wl-clip-persist
      waypipe
    ];
    programs = {
      plasma = {
        # Make us declarative, daddy
        overrideConfig = true;
        enable = true;
        shortcuts = import ./shortcuts.nix;
        hotkeys.commands = {
          "launch-terminal" = {
            name = "Launch Ghostty";
            command = "ghostty";
            key = "Meta+Return";
          };
          "help-popup" = {
            name = "Show shortcuts popup";
            command = ''sh -c "ghostty --config-file=~/.config/ghostty/popup-config"'';
            key = "Meta+?";
          };
          "launcher" = {
            name = "Open Application Launcher";
            command = "vicinae toggle";
            key = "Meta+Space";
          };
          "clipboard-history" = {
            name = "Open Clipboard History";
            command = "vicinae vicinae://extensions/vicinae/clipboard/history";
            key = "Alt+Shift+Insert";
          };
          "spotify" = {
            name = "Spotify tui";
            command = ''sh -c "ghostty --config-file=~/.config/ghostty/spotify-player"'';
            key = "Meta+S";
          };
          "gif-search" = {
            name = "Open GIF Search";
            command = "vicinae vicinae://extensions/josephschmitt/gif-search/search";
            key = "Meta+G";
          };
          "emoji" = {
            name = "Open Emoji Search";
            command = "vicinae vicinae://extensions/vicinae/vicinae/search-emojis";
            key = "Meta+.";
          };
        };
        configFile = {
          kcminputrc = {
            "Libinput/1133/16519/Logitech G903 LS".NaturalScroll = true;
            "Libinput/1267/12793/ELAN067C:00 04F3:31F9 Touchpad".NaturalScroll = true;
            "Libinput/76/613/Apple Inc. Magic Trackpad".PointerAcceleration = 0.400;
            "Libinput/76/613/Apple Inc. Magic Trackpad".ScrollFactor = 5;
          };
          kdeglobals = {
            General = {
              TerminalApplication = "ghostty";
              TerminalService = "com.mitchellh.ghostty.desktop";
            };
            KDE.AnimationDurationFactor = 0.17677669529663687;
            "KFileDialog Settings" = {
              "Allow Expansion" = false;
              "Automatically select filename extension" = true;
              "Breadcrumb Navigation" = false;
              "Decoration position" = 2;
              "Show Full Path" = true;
              "Show Inline Previews" = true;
              "Show Preview" = true;
              "Show Speedbar" = true;
              "Show hidden files" = true;
              "Sort by" = "Date";
              "Sort directories first" = true;
              "Sort hidden files last" = false;
              "Sort reversed" = false;
              "Speedbar Width" = 140;
              "View Style" = "DetailTree";
            };
            Shortcuts = {
              Copy = "Ctrl+C; Meta+C; Ctrl+Ins";
              CreateFolder = "Meta+Shift+N; Ctrl+Shift+N";
              Cut = "Ctrl+X; Meta+X";
              New = "Ctrl+N; Meta+N";
              Paste = "Ctrl+V; Shift+Ins; Meta+V";
              Preferences = "Meta+,";
              Save = "Ctrl+S; Meta+S";
              SaveAs = "Ctrl+Shift+S; Meta+Shift+S";
            };
          };
          kwalletrc.Wallet."First Use" = false;
          kwinrc = {
            Effect-overview.BorderActivate = 9;
            ElectricBorders.BottomRight = "LockScreen";
            Plugins = {
              karouselEnabled = true;
              magnifierEnabled = false;
              screenedgeEnabled = false;
              slideEnabled = false;
              slidingpopupsEnabled = false;
              zoomEnabled = false;
            };
            Script-karousel = {
              floatingKeepAbove = true;
              presetWidths = "50%, 30%, 70%";
              reMaximize = true;
              tiledKeepBelow = false;
              windowRules = ''
                [
                    {
                        "class": "(org\\.kde\\.)?plasmashell",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?polkit-kde-authentication-agent-1",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?kded6",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?kcalc",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?kfind",
                        "tile": true
                    },
                    {
                        "class": "(org\\.kde\\.)?kruler",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?krunner",
                        "tile": false
                    },
                    {
                        "class": "(org\\.kde\\.)?yakuake",
                        "tile": false
                    },
                    {
                        "class": "steam",
                        "caption": "Steam Big Picture Mode",
                        "tile": false
                    },
                    {
                        "class": "zoom",
                        "caption": "Zoom Cloud Meetings|zoom|zoom <2>",
                        "tile": false
                    },
                    {
                        "class": "jetbrains-.*",
                        "caption": "splash",
                        "tile": false
                    },
                    {
                        "class": "jetbrains-.*",
                        "caption": "Unstash Changes|Paths Affected by stash@.*",
                        "tile": true
                    },
                    {
                        "class": "com.mitchellh.ghostty-popup-.*",
                        "tile": false
                    }
                ]
              '';
            };
            Xwayland.Scale = 1.75;
            "org.kde.kdecoration2" = {
              BorderSize = "NoSides";
              BorderSizeAuto = false;
            };
          };
          plasma-localerc.Formats = {
            LANG = "en_US.UTF-8";
            LC_ADDRESS = "C";
            LC_MEASUREMENT = "nb_NO.UTF-8";
            LC_MONETARY = "nb_NO.UTF-8";
            LC_NAME = "C";
            LC_NUMERIC = "nb_NO.UTF-8";
            LC_PAPER = "nb_NO.UTF-8";
            LC_TELEPHONE = "C";
            LC_TIME = "en_DK.UTF-8";
          };
          spectaclerc = {
            ImageSave.translatedScreenshotsFolder = "Screenshots";
            VideoSave.translatedScreencastsFolder = "Screencasts";
          };
        };
        kwin = {
          effects = {
            blur.enable = true;
            desktopSwitching = {
              animation = "off";
              navigationWrapping = true;
            };
            dimInactive.enable = true;
            dimAdminMode.enable = true;
            windowOpenClose.animation = "off";
          };
          virtualDesktops = {
            names = [
              ""
              ""
              ""
              "󰭹"
              "󰝚"
              "󰱫"
            ];
            rows = 1;
          };
        };
        fonts = {
          fixedWidth = {
            family = "JetBrainsMono Nerd Font Mono";
            pointSize = 10;
          };
          general = {
            family = "JetBrainsMono Nerd Font Propo";
            pointSize = 10;
          };
          menu = {
            family = "JetBrainsMono Nerd Font Propo";
            pointSize = 10;
          };
          small = {
            family = "JetBrainsMono Nerd Font Propo";
            pointSize = 8;
          };
          toolbar = {
            family = "JetBrainsMono Nerd Font Propo";
            pointSize = 10;
          };
          windowTitle = {
            family = "JetBrainsMono Nerd Font Propo";
            pointSize = 10;
          };
        };
        input.keyboard = {
          repeatDelay = 300;
          repeatRate = 40;
        };
        krunner = {
          activateWhenTypingOnDesktop = true;
          historyBehavior = "enableSuggestions";
          shortcuts.launch = "Meta+Shift+Space";
          position = "center";
        };
        kscreenlocker = {
          appearance.wallpaperPictureOfTheDay.provider = "bing";
          lockOnResume = true;
        };
        panels = import ./panels.nix;
        powerdevil = {
          AC = {
            displayBrightness = 80;
            autoSuspend.action = "nothing";
            powerProfile = "performance";
          };
          battery = {
            displayBrightness = 40;
            autoSuspend = {
              action = "sleep";
              idleTimeout = 600;
            };
            powerProfile = "powerSaving";
          };
        };
        session = {
          sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
        };
        window-rules = [
          {
            description = "Window settings for com.mitchellh.ghostty";
            apply = {
              noborder = {
                value = true;
                apply = "force";
              };
            };
            match = {
              window-class = {
                value = "ghostty com.mitchellh.ghostty";
                type = "substring";
              };
              window-types = [ "normal" ];
            };
          }
          {
            description = "Window settings for com.mitchellh.ghostty-popup-help";
            apply = {
              noborder = {
                value = true;
                apply = "force";
              };
              placementrule = {
                value = 2;
              };
            };
            match = {
              window-class = {
                value = "ghostty com.mitchellh.ghostty-popup-help";
                type = "exact";
              };
              window-types = [ "normal" ];
            };
          }
          {
            description = "Window settings for com.mitchellh.ghostty-popup-spotify";
            apply = {
              noborder = {
                value = true;
                apply = "force";
              };
              placementrule = {
                value = 2;
              };
              size = {
                value = "900,750";
              };
            };
            match = {
              window-class = {
                value = "ghostty com.mitchellh.ghostty-popup-spotify";
                type = "exact";
              };
              window-types = [ "normal" ];
            };
          }
        ];
        workspace = {
          colorScheme = "CatppuccinMochaLavender";
          cursor = {
            theme = "Catppuccin-Mocha-Lavender-cursors";
            size = 24;
          };
          iconTheme = "breeze-dark";
          wallpaper = "/etc/nixos/wallpaper/Cloudsnight.jpg";
          windowDecorations = {
            library = "org.kde.kwin.aurorae";
            theme = "__aurorae__svg__CatppuccinMocha-Classic";

          };
          splashScreen.theme = "Catppuccin-Mocha-Lavender";
        };
      };
      okular = {
        enable = true;
        general = {
          mouseMode = "TextSelect";
          obeyDrm = false;
          zoomMode = "fitWidth";
        };
      };
      vicinae = {
        enable = true;
        package = inputs.nixpkgs-small.legacyPackages.x86_64-linux.vicinae;
        systemd.enable = true;
        settings = {
          font = {
            size = 11;
            normal = "JetBrainsMono Nerd Font Propo";
          };
          window = {
            csd = true;
            opacity = 0.94;
            rounding = 10;
          };
          theme.name = "catppuccin-mocha";

        };
        extensions = [
          (config.lib.vicinae.mkRayCastExtension {
            name = "gif-search";
            sha256 = "sha256-F0Q/xSytdlFRDAkr9pB9Zf2ys4FjHpw5+VbJf0fHVrw=";
            rev = "b8c8fcd7ebd441a5452b396923f2a40e879565ba";
          })
        ];
      };
    };
    xdg.configFile."vicinae/vicinae.json".force = true;
  };
}
