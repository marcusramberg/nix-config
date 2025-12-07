{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  isNiri = (lib.hasAttr "niri" osConfig.programs) && osConfig.programs.niri.enable;
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
}
