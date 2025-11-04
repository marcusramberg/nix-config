{
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
    programs.plasma = {
      enable = true;
      shortcuts = import ./shortcuts.nix;
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
                      "class": "com.mitchellh.ghostty-popup",
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
        kwinrulesrc = {
          General = {
            count = 2;
            rules = "e211d755-ce95-4f95-91c4-62ba5b483170,0890b4cc-54cf-408f-bbe6-a37ebd42858a";
          };
          "0890b4cc-54cf-408f-bbe6-a37ebd42858a" = {
            Description = "Window settings for com.mitchellh.ghostty";
            noborder = true;
            noborderrule = 3;
            title = "mwork: ~/S/r/a/tectonics";
            types = 1;
            wmclass = "ghostty com.mitchellh.ghostty";
            wmclasscomplete = true;
            wmclassmatch = 1;
          };
          "8dcedf51-5cf8-421e-b548-d563a7d77dc4"."noborderrule" = 3;
          "e211d755-ce95-4f95-91c4-62ba5b483170" = {
            "Description" = "Window settings for com.mitchellh.ghostty-popup";
            above = true;
            aboverule = 3;
            noborder = true;
            noborderrule = 3;
            placementrule = 2;
            title = "Ghostty";
            types = 1;
            wmclass = "ghostty com.mitchellh.ghostty-popup";
            wmclasscomplete = true;
            wmclassmatch = 1;
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
            ""
            "󰭹"
            "󰝚"
            ""
          ];
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
        shortcuts.launch = "Meta+Space";
        position = "center";
      };
      kscreenlocker = {
        appearance.wallpaperPictureOfTheDay.provider = "bing";
        lockOnResume = true;
      };
      panels = import ./panels.nix;
      session = {
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
      # window-rules = [ ];
      workspace = {
        colorScheme = "CatppuccinMochaLavender";
        cursor = {
          theme = "catppuccin-mocha-lavender-cursors";
          size = 24;
        };
        theme = "breeze-dark";
        iconTheme = "breeze-dark";
        wallpaper = "/etc/nixos/wallpaper/Cloudsnight.jpg";
        windowDecorations = {
          theme = "CatppuccinMocha-Classic";
          library = "org.kde.kdecoration2";
        };
      };
    };
    programs = {
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
        systemd.enable = true;
        settings = {
          theme = "base16-catppuccin-mocha";
        };
        themes = {
          base16-catppuccin-mocha = {
            version = "1.0.0";
            appearance = "dark";
            name = "base16 catppuccin mocha ";
            description = "base16 catppuccin mocha";
            palette = {
              background = "#1e1e2e";
              foreground = "#cdd6f4";
              blue = "#89b4fa";
              green = "#a6e3a1";
              magenta = "#cba6f7";
              orange = "#f9e2af";
              purple = "#b4befe";
              red = "#f38ba8";
              yellow = "#f5e0dc";
              cyan = "#94e2d5";
            };
          };
        };
        # extensions = [
        #   (lib.vicinae.mkRayCastExtension {
        #     name = "gif-search";
        #     sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
        #     rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
        #   })
        # ];
      };
    };
  };
}
