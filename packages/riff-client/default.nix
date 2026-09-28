{
  lib,
  stdenv,
  alsa-lib,
  appstream,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  fetchurl,
  gettext,
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
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riff";
  version = "26.7.0-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "Diegovsky";
    repo = "riff";
    rev = "1ef7260fd3d813ddda280cb47138e82ba5f93a9a";
    hash = "sha256-3sLR+XrbbiYjeHY8SQaaw4yESzlpnegMHCl7O9NAmlU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3evIgOfZgHMbsXKGnhIVfBlwBBLe2GV0Lf588KpesEE=";
  };

  # generated/ is gitignored; mirrors scripts/generate-spotify-api.sh, whose
  # pinned generator version has to match the reqwest in Cargo.lock
  openapiGenerator = fetchurl {
    url = "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.12.0/openapi-generator-cli-7.12.0.jar";
    hash = "sha256-M+ffp6HwTVhAXuEq4Z4sb8KpFJfPLlb6aPGHWpXL8iA=";
  };

  postPatch = ''
    java -jar $openapiGenerator generate \
      -i spotify-openapi.yaml -g rust -o generated/spotify-api \
      --package-name spotify-api \
      --additional-properties=library=reqwest,supportMiddleware=true

    substituteInPlace src/meson.build --replace-fail \
      "cargo_output = 'src' / rust_target / meson.project_name()" \
      "cargo_output = 'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    cargo
    desktop-file-utils
    gettext
    # glib
    #    gtk4
    meson
    ninja
    jre_headless
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
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
