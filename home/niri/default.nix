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
    sessionVariables.QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${pkgs.quickshell}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
    ];
  };
}
