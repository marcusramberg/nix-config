{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.limine;
in
{
  options.profiles.limine.enable = lib.mkEnableOption "Enable config for amd gpu";
  options.profiles.limine.secureboot = lib.mkEnableOption "Enable secureboot";

  config = lib.mkIf cfg.enable {
    boot.loader = {
      limine = {
        enable = true;
        maxGenerations = 4;
        secureBoot.enable = cfg.secureboot;
        style = {
          interface = {
            branding = "if found, please return to Marcus Ramberg - 94357747";
            resolution = "1920x1200";
          };
          graphicalTerminal = {
            palette = "4c4f69;d20f39;40a02b;dc8a78;1e66f5;ea76cb;209fb5;7c7f93";
            font.scale = "3x3";
          };
          wallpapers = [
            ../wallpaper/tokyonight.jpg
          ];
        };
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
