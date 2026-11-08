{
  config,
  lib,
  inputs,
  options,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  # quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dms = inputs.dux-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dmsRegistry = inputs.dms-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system};
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  schemaDir = pkgs.glib.makeSchemaPath gsettingsSchemas gsettingsSchemas.name;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "dms desktop environment";
    shell = lib.mkOption {
      type = lib.types.enum [
        "dux"
        "fjordxy"
      ];
      default = "dux";
      description = ''
        Which shell to run on top of niri. `fjordxy` needs the fjordxy NixOS
        module imported, which `mkDesktopHost` does when given `shell = "fjordxy"`.
      '';
    };
    displayManager = lib.mkEnableOption "display manager (dux-greeter, or fjordxy's greeter)" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.shell != "fjordxy" || options.programs ? fjordxy;
            message = "profiles.desktop.shell = \"fjordxy\" needs inputs.fjordxy.nixosModules.default (use mkDesktopHost with shell = \"fjordxy\").";
          }
        ];

        hardware.i2c.enable = true;

        # Enable plymouth
        boot = {
          plymouth.enable = true;
          consoleLogLevel = 3;
          kernelParams = [
            "quiet"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
          ];
        };

        environment = {
          sessionVariables = {
            GSETTINGS_SCHEMA_DIR = schemaDir;
            NIXOS_OZONE_WL = "1";
          };
          systemPackages =
            with pkgs;
            [
              adw-gtk3
              bazaar
              bitwarden-desktop
              distrobox
              element-desktop
              ghostty
              hunspell
              hunspellDicts.en_US
              dux-calendar
              nautilus
              neovide
              showmethekey
              vlc
              wl-clipboard
              wl-clip-persist
              waypipe
              (vivaldi.override {
                enableWidevine = true;
                proprietaryCodecs = true;
              })
              spotify-player
              telegram-desktop
              signal-desktop
              vesktop
              wtype
            ]
            ++ (with kdePackages; [
              breeze-icons
              kaccounts-providers
              qt6ct
              qtdeclarative
              tokodon
            ]);
        };

        profiles.myfonts.enable = true;
        programs = {
          evolution.enable = false;
          gnome-terminal.enable = false;
          foot = {
            enable = true;
            enableFishIntegration = true;
          };
          kdeconnect.enable = true;
          nautilus-open-any-terminal = {
            enable = true;
            terminal = "foot";
          };
          seahorse.enable = true;
          ssh.enableAskPassword = true;
        };

        services = {
          keybase.enable = true;
          gnome.evolution-data-server.enable = lib.mkForce false;
          gnome.at-spi2-core.enable = true;
          flatpak.enable = true;
          orca.enable = false;
          power-profiles-daemon.enable = true;
          upower.enable = true;

          xserver = {
            enable = false;
            xkb = {
              layout = "us";
              options = "eurosign:e";
              variant = "mac";
            };
          };
        };
        security = {
          pam.services = {
            greetd.fprintAuth = lib.mkDefault false;
          };
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
          tpm2.enable = true;
        };
        xdg = {
          portal.xdgOpenUsePortal = true;
          mime = {
            enable = true;
            defaultApplications."inode/directory" = "dolphin.desktop";
          };
        };
      }

      (lib.mkIf (cfg.shell == "dux") {
        boot.plymouth = {
          theme = lib.mkForce "nixos";
          themePackages = [ pkgs.plymouth-nixos ];
        };

        programs = {
          dux-shell = {
            enable = true;
            package = dms;
            # quickshell.package = quickshell;
            plugins = {
              dankActions = {
                enable = true;
                src = dmsRegistry.dankActions;
              };
              dankGifSearch = {
                enable = true;
                src = dmsRegistry.dankGifSearch;
              };
              dankStickerSearch = {
                enable = true;
                src = dmsRegistry.dankStickerSearch;
              };
              dankLauncherKeys = {
                enable = true;
                src = dmsRegistry.dankLauncherKeys;
              };
              dankKDEConnect = {
                enable = true;
                src = dmsRegistry.dankKDEConnect;
              };
              dankPomodoroTimer = {
                enable = true;
                src = dmsRegistry.dankPomodoroTimer;
              };
              worldClock = {
                enable = true;
                src = dmsRegistry.worldClock;
              };
              quickCapture = {
                enable = true;
                src = dmsRegistry.quickCapture;
              };
            };
          };
          dux-search.enable = true;
          mango.enable = true;
          # Kept as a fallback session while migrating to mango.
          niri.enable = true;
        };

        qt = {
          enable = true;
          style = "breeze";
        };

        systemd = {
          # nixpkgs' mango module doesn't install mango-session.target, which mango
          # starts on launch to bring up graphical-session.target.
          packages = [ config.programs.mango.package ];
          # DMS is WantedBy graphical-session.target, which the SteamOS/gamescope
          # session also activates — there it crash-loops without a usable wayland
          # socket. Only start it from the compositor sessions instead.
          user.services.dms = {
            partOf = [ "graphical-session.target" ];
            wantedBy = lib.mkForce [
              "mango-session.target"
              "niri.service"
            ];
            after = [
              "mango-session.target"
              "niri.service"
            ];
          };
        };

        services = {
          displayManager = lib.mkIf cfg.displayManager {
            dux-greeter = {
              enable = true;
              # quickshell.package = quickshell;
              # The greeter runs in its own compositor, independent of the session.
              # Its "mangowc" option passes a name dms-greeter doesn't recognise.
              compositor.name = "niri";
              configHome = "/home/marcus";
            };
            # niri.nix also sets this with mkDefault; beat it but stay overridable.
            defaultSession = lib.mkOverride 900 "mango";
          };
          desktopManager.gnome.enable = true;
        };
      })

      (lib.mkIf (cfg.shell == "fjordxy") (
        lib.optionalAttrs (options.programs ? fjordxy) {
          boot.plymouth = {
            theme = "fjordxy";
            themePackages = [ pkgs.plymouth-fjordxy ];
          };
          # fjordxy's HM module reads its options from osConfig, so it only
          # goes into home-manager on hosts that import the NixOS side.
          home-manager.sharedModules = [ inputs.fjordxy.homeModules.default ];
          programs.fjordxy = {
            enable = true; # the shell
            desktop.enable = true; # compositor, greeter, portals, audio
            desktop.greeter = lib.mkIf (!cfg.displayManager) "none";
            identity.username = "marcus";
          };
        }
      ))
    ]
  );
}
