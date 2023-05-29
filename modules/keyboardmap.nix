{ pkgs, ... }: {
  services = {
    interception-tools = let
      # Map caps lock to:
      # - ESC when tapped
      # - LCTRL when held
      dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" ''
        MAPPINGS:
          # CAPS (tap) -> ESC, CAPS (hold) -> LCTRL
          - KEY: KEY_CAPSLOCK
            TAP: KEY_ESC
            HOLD: KEY_LEFTCTRL

          # # Swap LALT with LCTRL
          # - KEY: KEY_LEFTALT
          #   TAP: KEY_LEFTCTRL
          #   HOLD: KEY_LEFTCTRL
          #   HOLD_START: BEFORE_CONSUME
          #
          # # Swap LCTRL with LALT
          # - KEY: KEY_LEFTCTRL
          #   TAP: KEY_LEFTALT
          #   HOLD: KEY_LEFTALT
          #   HOLD_START: BEFORE_CONSUME
      '';
    in {
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dualFunctionKeysConfig} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            LINK: .*-event-kbd
      '';
    };
  };
}
