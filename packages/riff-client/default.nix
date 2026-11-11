{
  lib,
  stdenv,
  alsa-lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  fetchurl,
  glib,
  gtk4,
  libadwaita,
  libpulseaudio,
  meson,
  ninja,
  jre_headless,
  openssl,
  pkg-config,
  rustPlatform,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riff";
  version = "26.10-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "Diegovsky";
    repo = "riff";
    rev = "37bb80be6398b64d26dbfa71e15dd6c9e1e67eb3";
    hash = "sha256-w8EZCAeRdb7wYKU6nLbMcwyhYpYat/Wd46PrjYhNCaY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-C+AFi8d0AlLB4kbUJz/7/fEDP1pVTRxBWsbHhRH/lP8=";
  };

  # generated/ is gitignored; mirrors scripts/api/generate-spotify-api.sh, whose
  # pinned generator version has to match the reqwest in Cargo.lock
  openapiGenerator = fetchurl {
    url = "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.12.0/openapi-generator-cli-7.12.0.jar";
    hash = "sha256-M+ffp6HwTVhAXuEq4Z4sb8KpFJfPLlb6aPGHWpXL8iA=";
  };

  postPatch = ''
    java -jar $openapiGenerator generate \
      -i spotify-openapi.yaml -g rust -o generated/spotify-api \
      --package-name spotify-api \
      --additional-properties=library=reqwest,supportMiddleware=true \
      --type-mappings=file=String

    substituteInPlace src/meson.build --replace-fail \
      "cargo_output = 'src' / rust_target / meson.project_name()" \
      "cargo_output = 'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    jre_headless
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk4
    libadwaita
    libpulseaudio
    openssl
  ];

  mesonBuildType = "release";

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Native Spotify client for the GNOME desktop";
    homepage = "https://github.com/Diegovsky/riff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcusramberg ];
    mainProgram = "riff";
    platforms = lib.platforms.linux;
  };
})
