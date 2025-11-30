{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNiri = (lib.hasAttr "niri" osConfig.programs) && osConfig.programs.niri.enable;
in
{
  home = mkIf isNiri {
    packages = with pkgs; [
      sway-contrib.grimshot
      satty
    ];
    sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${pkgs.quickshell}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
    ];
  };
  programs = mkIf isNiri {
    dankMaterialShell = {
      enable = true;
      niri.enableSpawn = true;
    };
    niri = {
      settings = {
        hotkey-overlay = {
          skip-at-startup = true;
          hide-not-bound = true;
        };
        prefer-no-csd = true;
        input = {
          keyboard.xkb = {
            inherit (osConfig.services.xserver.xkb) layout options variant;
          };

          touchpad = {
            tap = true;
            natural-scroll = true;
          };

          mouse = {
            accel-profile = "flat";
            natural-scroll = true;
          };
          workspace-auto-back-and-forth = true;
        };
        binds = import ./binds.nix { inherit config; };
        outputs = {
          "eDP-1".scale = 1.1;
          "DP-1".scale = 1.25;
        };

        layout = {
          gaps = 6;

          center-focused-column = "never";
          always-center-single-column = true;

          preset-column-widths = [
            { proportion = 0.3; }
            { proportion = 0.5; }
            { proportion = 0.7; }
          ];

          default-column-width = {
            proportion = 0.5;
          };

          focus-ring = {
            width = 1;
            active = {
              color = "#fab387";
            };
            inactive = {
              color = "#b4befe";
            };
          };

          shadow = {
            enable = true;
            softness = 30;
            spread = 4;
          };
        };
        window-rules = [
          {
            draw-border-with-background = false;
            geometry-corner-radius = {
              bottom-left = 0.0;
              bottom-right = 0.0;
              top-left = 0.0;
              top-right = 0.0;
            };
          }
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }
        ];
        animations.workspace-switch.enable = false;
        workspaces = {
          "01-terminal" = {
            name = "terminal";
          };
          "02-browser" = {
            name = "browser";
          };
          "03-music" = {
            name = "music";
          };
          "04-chat" = {
            name = "chat";
          };
        };
        environment = {
          QT_QPA_PLATFORM = "wayland";
        };
      };
    };
  };
}
