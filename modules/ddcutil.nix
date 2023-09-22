{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.programs.custom.ddcutil;
in {
  options.programs.custom.ddcutil = {
    enable = mkOption {
      default = false;
      type = types.bool;
      example = true;
    };
    users = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ "myusername" ];
    };

  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

    services.udev.extraRules = builtins.readFile
      "${pkgs.ddcutil}/share/ddcutil/data/45-ddcutil-i2c.rules";

    environment.systemPackages = [ pkgs.ddcutil ];
    users.groups = { "i2c" = { }; };
    users.users =
      lib.foldl' (user: _: { ${user}.extraGroups = [ "i2c" ]; }) config.users
      cfg.users;

  };
}
