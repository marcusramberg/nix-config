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
    enable = lib.mkEnableOption "Enable dual esc/ctrl caps lock";
    swapAlt = lib.mkEnableOption "Also swap alt/meta";
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
            - KEY: KEY_LEFTMETA
              HOLD: KEY_LEFTALT
              TAP: KEY_LEFTALT
            - KEY: KEY_LEFTALT
              HOLD: KEY_LEFTMETA
              TAP: KEY_LEFTMETA
        '';
      in
      {
        enable = true;
        plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
        udevmonConfig = ''
          - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dualFunctionKeysConfig} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
            DEVICE:
              LINK: .*-event-kbd
          - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${swapAlt} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
            DEVICE:
              NAME: "Targus Folding Ergonomic Bluetooth Keyboard"
        '';
      };
    # link bluetooth keyboards
    udev.extraRules = ''
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Targus Folding Ergonomic Bluetooth Keyboard", SYMLINK+="input/by-path/mfold.input-event-kbd"
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="mBoard", SYMLINK+="input/by-path/mboard.input-event-kbd"
    '';
  };
}
