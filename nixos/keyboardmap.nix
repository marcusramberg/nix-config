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
    enable = lib.mkEnableOption "Enable keyboard remapping (caps2esc/ctrl and cmd-v/c -> ctrl/shift-insert";
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
        dualFunctionKeys = ''
          MAPPINGS:
          # CAPS (tap) -> ESC, CAPS (hold) -> LCTRL
            - KEY: KEY_CAPSLOCK
              TAP: KEY_ESC
              HOLD: KEY_LEFTCTRL
          # tab as hyper when used in a chord.
            - KEY: KEY_TAB
              TAP: KEY_TAB
              HOLD: [KEY_LEFTCTRL,KEY_LEFTMETA,KEY_LEFTALT,KEY_LEFTSHIFT]
              HOLD_START: BEFORE_CONSUME
        '';
        dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" dualFunctionKeys;
        swapAlt = pkgs.writeText "swap-alt.yaml" ''
          ${dualFunctionKeys}
          # swap alt and meta
            - KEY: KEY_LEFTMETA
              HOLD: KEY_LEFTALT
              TAP: KEY_LEFTALT
            - KEY: KEY_LEFTALT
              HOLD: KEY_LEFTMETA
              TAP: KEY_LEFTMETA
        '';
        universalClipboard = import ../packages/universal-clipboard { inherit pkgs; };
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
          (lib.optionalString cfg.swapAlt.enable ''
            - JOB: "${intercept} -g $DEVNODE | ${dual} -c ${swapAlt} | ${uc} | ${uinput} -d $DEVNODE"
              DEVICE:
                LINK: /dev/input/by-path/${cfg.swapAlt.device}
          '')
          + ''
            - JOB: "${intercept} -g $DEVNODE | ${dual} -c ${dualFunctionKeysConfig} | ${uc} | ${uinput} -d $DEVNODE"
              DEVICE:
                LINK: .*-event-kbd
          '';
      };
    # link bluetooth keyboards
    udev.extraRules = ''
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Targus Folding Ergonomic Bluetooth Keyboard", SYMLINK+="input/by-path/mfold.input-event-kbd"
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="mBoard", SYMLINK+="input/by-path/mboard.input-event-kbd"
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Milla Rambergs tastatur", SYMLINK+="input/by-path/tvboard.input-event-kbd"
    '';
  };
}
