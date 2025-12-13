{
  lib,
  config,
  osConfig,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNiri = (lib.hasAttr "programs" osConfig) && osConfig.programs.niri.enable;
in
{
  home = mkIf isNiri {
    packages = with pkgs; [
      inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.targetPlatform.system}.xwayland-satellite
      libnotify
      satty
      wvkbd
    ];
  };
  programs = mkIf isNiri {
    vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        font = {
          size = 11;
          normal = "JetBrainsMono Nerd Font Propo";
        };
        window = {
          csd = true;
          opacity = 0.94;
          rounding = 10;
        };
        theme.name = "catppuccin-mocha";

      };
      extensions = [
        (config.lib.vicinae.mkRayCastExtension {
          name = "gif-search";
          sha256 = "sha256-F0Q/xSytdlFRDAkr9pB9Zf2ys4FjHpw5+VbJf0fHVrw=";
          rev = "b8c8fcd7ebd441a5452b396923f2a40e879565ba";
        })
      ];
    };
  };
}
