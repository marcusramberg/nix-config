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
        input = {
          keyboard.xkb = {
            layout = "us";
            options = "eurosign:e";
            variant = "mac";
          };

          touchpad = {
            tap = true;
            natural-scroll = true;
          };

          mouse.accel-profile = "flat";
        };
        binds = import ./binds.nix { inherit config; };
        layout = {
          gaps = 6;

          center-focused-column = "never";

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
              color = "#04a5e5";
            };
            inactive = {
              color = "#7c7f93";
            };
          };

          shadow = {
            enable = true;
            softness = 30;
            spread = 4;
          };
        };
        window-rules = [
          # {
          #   geometry-corner-radius = {
          #     bottom-left = 15.0;
          #     bottom-right = 15.0;
          #     top-left = 15.0;
          #     top-right = 15.0;
          #   };
          #   clip-to-geometry = true;
          # }
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
      };
    };
  };
}
