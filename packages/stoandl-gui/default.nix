{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qtbase,
  qtdeclarative,
  wrapQtAppsHook,
  kirigami,
  kirigami-addons,
  qqc2-desktop-style,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stoandl-gui";
  version = "0.4.0-unstable-2026-11-17";

  # Head of yoxcu/stoandl-gui#1 (Rebble store); needs the daemon from
  # yoxcu/stoandl#4.
  src = fetchFromGitHub {
    owner = "yoxcu";
    repo = "stoandl-gui";
    rev = "425329eacd19b7fed8949da6cdfd13b9d88277a7";
    hash = "sha256-69y3BnQ1QHU6n5zXnAa0aJup11RCo3W3HAPqSBk6+2Y=";
  };

  # The CMake project is in kirigami/ and installs from the sibling data/.
  sourceRoot = "${finalAttrs.src.name}/kirigami";

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    # QML-only, found at run time through the wrapper.
    kirigami
    kirigami-addons
    qqc2-desktop-style
  ];

  cmakeFlags = [ (lib.cmakeFeature "STOANDL_GUI_VERSION" finalAttrs.version) ];

  meta = {
    description = "Kirigami front-end for the stoandl Pebble companion daemon";
    homepage = "https://github.com/yoxcu/stoandl-gui";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "stoandl-gui";
  };
})
