{ config, lib, ... }:
with lib;
let cfg = config.profile.laptop;
in {
  options.profile.laptop.enable = mkEnableOption "Enable laptop profile";
  config = mkIf cfg.enable {
    programs.light.enable = true;
    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -A 10";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -U 10";
        }
      ];
    };
  };
}

