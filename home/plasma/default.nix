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
        baloofilerc.General = {
          dbVersion = 2;
          "exclude filters" =
            "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
          "exclude filters version" = 9;
        };
        dolphinrc = {
          General.ViewPropsTimestamp = "2025,8,24,14,50,21.056";
          "KFileDialog Settings" = {
            "Places Icons Auto-resize" = false;
            "Places Icons Static Size" = 22;
          };
        };
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
            "Show Full Path" = false;
            "Show Inline Previews" = true;
            "Show Preview" = false;
            "Show Speedbar" = true;
            "Show hidden files" = false;
            "Sort by" = "Date";
            "Sort directories first" = true;
            "Sort hidden files last" = false;
            "Sort reversed" = false;
            "Speedbar Width" = 140;
            "View Style" = "DetailTree";
          };
          Shortcuts = {
            AboutApp = "";
            AboutKDE = "";
            Clear = "";
            ConfigureNotifications = "";
            ConfigureToolbars = "";
            Copy = "Ctrl+C; Meta+C; Ctrl+Ins";
            CreateFolder = "Meta+Shift+N; Ctrl+Shift+N";
            Cut = "Ctrl+X; Meta+X";
            Donate = "";
            EditBookmarks = "";
            FitToHeight = "";
            FitToPage = "";
            FitToWidth = "";
            Goto = "";
            GotoPage = "";
            Mail = "";
            New = "Ctrl+N; Meta+N";
            OpenRecent = "";
            Paste = "Ctrl+V; Shift+Ins; Meta+V";
            Preferences = "Meta+,; Ctrl+Shift+,";
            PrintPreview = "";
            ReportBug = "";
            Revert = "";
            Save = "Ctrl+S; Meta+S";
            SaveAs = "Ctrl+Shift+S; Meta+Shift+S";
            ShowStatusbar = "";
            ShowToolbar = "";
            Spelling = "";
            SwitchApplicationLanguage = "";
            Zoom = "";
          };
          WM = {
            activeBackground = "30,30,46";
            activeBlend = "205,214,244";
            activeForeground = "205,214,244";
            inactiveBackground = "17,17,27";
            inactiveBlend = "166,173,200";
            inactiveForeground = "166,173,200";
          };
        };
        kscreenlockerrc = {
          Daemon.Timeout = 10;
          Greeter.WallpaperPlugin = "org.kde.potd";
          "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
        };
        kwalletrc.Wallet."First Use" = false;
        kwinrc = {
          Desktops = {
            Id_1 = "f2a60743-1874-4a2e-80cd-8595c3bb1899";
            Id_2 = "feffcc45-ea46-4724-bf1f-cac62d951733";
            Id_3 = "3ce97ee5-7a5a-440f-aaba-b24059cfba57";
            Id_4 = "9ce0f43c-ff5e-4423-aed4-6f7a80518ad4";
            Id_5 = "8b4130a7-9668-4f64-abfa-cf07892a5962";
            Id_6 = "8c9e427e-2fcf-4498-ac17-ea36564430be";
            Number = 6;
            Rows = 1;
          };
          Effect-overview.BorderActivate = 9;
          ElectricBorders.BottomRight = "LockScreen";
          Plugins = {
            fadedesktopEnabled = true;
            karouselEnabled = true;
            magnifierEnabled = true;
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
            theme = "Breeze";
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
        plasmaparc = {
          General.GlobalMute = true;
          Wallpapers.usersWallpapers = "/etc/nixos/wallpaper/Cloudsnight.jpg";
        };
        spectaclerc = {
          ImageSave.translatedScreenshotsFolder = "Screenshots";
          VideoSave.translatedScreencastsFolder = "Screencasts";
        };
      };
    };
  };
}
