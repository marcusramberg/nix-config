{ config, pkgs, lib, ... }:
with lib;
let cfg = config.programs.custom.ddcutil;
in {
  options.programs.custom.ddcutil = {
    enable = mkEnableOption "ddcutil";
    user = mkOption {
      default = "";
      description = "User to run ddcutil as";
      type = types.str;
      example = "myusername";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

    services.udev.extraRules = builtins.readFile
      "${pkgs.ddcutil}/share/ddcutil/data/45-ddcutil-i2c.rules";

    environment.systemPackages = [ pkgs.ddcutil ];
    users.groups = { "i2c" = { }; };
    users.users =
      lib.mkIf (cfg.user != "") { ${cfg.user}.extraGroups = [ "i2c" ]; };
  };
}
