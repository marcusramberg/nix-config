{
  lib,
  stdenv,
  fetchFromGitea,
  glib,
  gtk4,
  libadwaita,
  meson,
  openssl,
  pkg-config,
  rustPlatform,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (_: {
  pname = "bitritter";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "oleksiidn";
    repo = "bitritter";
    rev = "0cec1a80f2715b04c7f048907299b8317de30877";
    hash = "sha256-gv+qLM/R7Ud76gkPyyasajzqGv0L66Z3PfHgdrrUsSA=";
  };

  cargoHash = "sha256-Pnani0UK3sRqnktjsk4dETyAexBlCUTgyvfnnbqduJE=";

  nativeBuildInputs = [
    glib
    gtk4
    libadwaita
    meson
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [ openssl ];

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  # build.rs runs sqlx migrations against the committed *.db3 files,
  # which creates -wal/-shm sidecars; keep them out of the install tree
  # (they are build-time only).
  postInstall = ''
    rm -f $out/share/bitritter/*.db3-* 2>/dev/null || true
  '';

  meta = with lib; {
    description = "BitWarden-compatible password manager";
    homepage = "https://codeberg.org/oleksiidn/bitritter";
    license = licenses.mit;
    maintainers = with maintainers; [ marcusramberg ];
    mainProgram = "bitritter";
    platforms = platforms.linux;
  };
})
