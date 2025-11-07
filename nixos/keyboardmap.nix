{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.keyboard.dual-caps;
in
{
  options.hardware.keyboard.dual-caps = {
    enable = lib.mkEnableOption "Enable keyboard remapping (caps2esc/ctrl and cmd-v/c -> insert";
    swapAlt.enable = lib.mkEnableOption "Also swap alt/meta";
    swapAlt.device = lib.mkOption {
      type = lib.types.str;
      default = "mfold.input-event-kbd";
      description = "Device to swap alt/meta keys on, defaults to the folding keyboard";
      example = "mboard.input-event-kbd";
    };
  };

  config.services = lib.mkIf cfg.enable {
    interception-tools =
      let
        # Map caps lock to:
        # - ESC when tapped
        # - LCTRL when held
        dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" ''
          MAPPINGS:
            # CAPS (tap) -> ESC, CAPS (hold) -> LCTRL
            - KEY: KEY_CAPSLOCK
              TAP: KEY_ESC
              HOLD: KEY_LEFTCTRL
            - KEY: KEY_TAB
              TAP: KEY_TAB
              HOLD: [KEY_LEFTCTRL,KEY_LEFTMETA,KEY_LEFTALT,KEY_LEFTSHIFT]
              HOLD_START: BEFORE_CONSUME
        '';
        swapAlt = pkgs.writeText "swap-alt.yaml" ''
          MAPPINGS:
            - KEY: KEY_CAPSLOCK
              TAP: KEY_ESC
              HOLD: KEY_LEFTCTRL
            - KEY: KEY_TAB
              TAP: KEY_TAB
              HOLD: [KEY_LEFTCTRL,KEY_LEFTMETA,KEY_LEFTALT,KEY_LEFTSHIFT]
              HOLD_START: BEFORE_CONSUME
            - KEY: KEY_LEFTMETA
              HOLD: KEY_LEFTALT
              TAP: KEY_LEFTALT
            - KEY: KEY_LEFTALT
              HOLD: KEY_LEFTMETA
              TAP: KEY_LEFTMETA
        '';
        clipboard = ''
          { .keys = { KEY_LEFTMETA, KEY_V },
           .down_press = { KEY_LEFTSHIFT, KEY_RESERVED, KEY_INSERT, KEY_RESERVED },
           .up_press   = { KEY_RESERVED, KEY_INSERT, KEY_RESERVED, KEY_LEFTSHIFT },
           DOWN_IFF_ALL_DOWN(2) },
          { .keys = { KEY_LEFTMETA, KEY_C },
           .down_press = { KEY_CNT, KEY_RESERVED, KEY_INSERT, KEY_RESERVED },
           .up_press   = { KEY_RESERVED, KEY_INSERT, KEY_RESERVED, KEY_CNT},
           DOWN_IFF_ALL_DOWN(2) }
        '';
        universalClipboard = pkgs.stdenv.mkDerivation {
          name = "universal-clipboard";

          src = pkgs.fetchFromGitHub {
            owner = "zsugabubus";
            repo = "interception-k2k";
            rev = "5746bf39a321610bb6019781034f82e4c6e21e97";
            hash = "sha256-q2zlOvyW5jlasEIPVc+k6jh2wJZ7sUEpvXh/leH/hKw=";
          };
          patches = [ ./k2k-multi.patch ];

          configurePhase = ''
            mkdir -p ./in/uc
            echo "${clipboard}" > ./in/uc/multi-rules.h.in
          '';

          makeFlags = [
            "OUT_DIR=$(out)"
            "INSTALL_DIR=$(out)/bin"
            "CONFIG_DIR=./in"
          ];

          meta = {
            description = "Map cmd+c/v to shift/ctrl-insert for universal clipboard sharing";
            mainProgram = "uc";
          };
        };
        uc = "${universalClipboard}/bin/uc";
        dual = "${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys";
        intercept = "${pkgs.interception-tools}/bin/intercept";
        uinput = "${pkgs.interception-tools}/bin/uinput";

      in
      {
        enable = true;
        plugins = [
          pkgs.interception-tools-plugins.dual-function-keys
          universalClipboard
        ];
        udevmonConfig =
          (
            if cfg.swapAlt.enable then
              ''
                - JOB: "${intercept} -g $DEVNODE | ${dual} -c ${swapAlt} | ${uinput} -d $DEVNODE" 
                  DEVICE: 
                    LINK: /dev/input/by-path/${cfg.swapAlt.device}
              ''
            else
              ""
          )
          + ''
            - JOB: "${intercept} -g $DEVNODE | ${dual} -c ${dualFunctionKeysConfig} | ${uinput} -d $DEVNODE"
              DEVICE: 
                LINK: .*-event-kbd
            - JOB: "${intercept} -g $DEVNODE | ${uc} | ${uinput} -d $DEVNODE"
              DEVICE: 
                LINK: .*-event-kbd
          '';
      };
    # link bluetooth keyboards
    udev.extraRules = ''
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Targus Folding Ergonomic Bluetooth Keyboard", SYMLINK+="input/by-path/mfold.input-event-kbd"
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="mBoard", SYMLINK+="input/by-path/mboard.input-event-kbd"
    '';
  };
}
