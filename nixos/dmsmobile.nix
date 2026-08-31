{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.dmsMobile;
  dms = inputs.dmsmobile.packages.${pkgs.stdenv.hostPlatform.system}.default;
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  schemaDir = pkgs.glib.makeSchemaPath gsettingsSchemas gsettingsSchemas.name;
in

{

  options = {
    profiles.dmsMobile = {
      enable = lib.mkEnableOption "Enable DMS Mobile configuration";
      debug.enable = lib.mkEnableOption "Enable additional debugging features, such as a serial console in the initrd";
      display = lib.mkOption {
        type = lib.types.str;
        default = "DSI-1";
        description = "Display output";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # Temp patch for wvkbd while we try to get it fixed upstream
    nixpkgs.overlays = [
      (_final: prev: {
        wvkbd = prev.wvkbd.overrideAttrs (o: {
          patches = (o.patches or [ ]) ++ [ ./wvkbd-show-reentrancy.patch ];
        });
      })
    ];

    boot = {
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      plymouth = {
        # Plymouth takes DRM master in the initrd and blanks unl0kr's LUKS prompt.
        enable = lib.mkDefault true;
        theme = "catppuccin-mocha";
        themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      };
      consoleLogLevel = lib.mkDefault 3;
      kernelParams = lib.mkOrder 1600 (
        [
          "boot.shell_on_fail"
          "rd.systemd.show_status=auto"
        ]
        ++ lib.optionals config.boot.plymouth.enable [
          "quiet"
          "udev.log_priority=3"
        ]
      );
    };
    environment = {
      sessionVariables = {
        GSETTINGS_SCHEMA_DIR = schemaDir;
        NIXOS_OZONE_WL = "1";
      };
      # GNOME's module defaults this to "ibus", which stops Qt binding
      # zwp_text_input_v3 at all, so wvkbd --auto never sees a text field.
      variables.QT_IM_MODULE = lib.mkForce "wayland";
      systemPackages = with pkgs; [
        bazaar
        firefox-mobile
        signal-desktop
        telegram-desktop
        wl-clipboard
      ];
    };
    programs = {
      dms-shell = {
        enable = true;
        package = dms;
      };
      dsearch.enable = true;
      foot = {
        enable = true;
        enableFishIntegration = true;
      };
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };
      springchick.enable = true;
    };
    services = {
      displayManager = {
        phrog = {
          enable = true;
          package = inputs.nixos-fairphone-fp5.pkgs.phrog;
        };
        defaultSession = lib.mkForce "springchick";
      };
      geoclue2.enable = true;
      gnome.at-spi2-core.enable = true;
      flatpak.enable = true;
      orca.enable = false;
      power-profiles-daemon.enable = lib.mkDefault true;
      upower.enable = true;

      logind.settings.Login = {
        HandlePowerKey = "ignore";
      };
    };
    security = {
      polkit = {
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
      pam.services = {
        greetd.fprintAuth = lib.mkForce false;
        login.fprintAuth = false;
      };
    };
    systemd = {
      user.services.dms.environment.DMS_MOBILE = "1";
      user.services = {
        dms.wantedBy = lib.mkForce [
          "springchick.service"
        ];
        wvkbd = {
          description = "On-screen keyboard";
          partOf = [ "graphical-session.target" ];
          wantedBy = [
            "niri.service"
            "springchick.service"
          ];
          serviceConfig = {
            ExecStart = "${pkgs.wvkbd}/bin/wvkbd-mobintl --alpha 220 --hidden --auto";
            Restart = "always";
            RestartSec = 5;
          };
        };
      };
      services.flatpak-remote-add-flathub = {
        description = "Add Flathub repository for Flatpak";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
          # Restart on failure (e.g., network not actually connected yet).
          Restart = "on-failure";
          RestartSec = "30s";
          # Give up after 20 attempts to avoid infinite retries.
          StartLimitBurst = 20;
        };
      };
    };

    virtualisation = {
      waydroid.enable = true;
    };
  };
}
