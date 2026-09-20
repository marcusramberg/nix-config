{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qtwayland,
  kcoreaddons,
  ki18n,
  layer-shell-qt,
  fetchFromGitHub,
  version ? "0.91",
}:

stdenv.mkDerivation {
  pname = "tastiera";
  inherit version;

  src = fetchFromGitHub {
    owner = "andreadelsarto";
    repo = "tastiera";
    rev = "98c6b42ba56493af5ac32d6a11bdffe757f02ee0";
    hash = "sha256-tZWViuUK7PdKvV6KDVH81Wr5Fx6jgFOCBjb3QHHgC5A=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    pkg-config
    qtbase
    qtdeclarative
    wayland-scanner
    wrapQtAppsHook
  ];

  # qtwayland: the wayland QPA plugin. wrapQtAppsHook points QT_PLUGIN_PATH and
  # QML2_IMPORT_PATH at these, which is how QtQuick.Controls resolves at runtime.
  buildInputs = [
    kcoreaddons
    ki18n
    layer-shell-qt
    qtbase
    qtdeclarative
    qtwayland
    wayland
  ];

  cmakeBuildType = "Release";

  # Upstream ships no qt_policy() calls, so the QML never makes it into the
  # binary and the app exits 255 (silently — see the patch header). Sent
  # upstream as a CMakeLists fix; drop this once the pinned rev has it.
  patches = [ ./tastiera-cmake-policies.patch ];

  meta = {
    description = "Qt6/LayerShell virtual keyboard using zwp_virtual_keyboard_v1";
    homepage = "https://github.com/andreadelsarto/tastiera";
    license = lib.licenses.gpl3Only;
    mainProgram = "plasma-keyboard";
    platforms = lib.platforms.linux;
  };
}
