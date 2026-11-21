{
  lib,
  rustPlatform,
  clangStdenv,
  fetchFromGitea,
  fetchFromGitHub,
  fetchgit,
  linkFarm,
  runCommand,
  gn,
  ninja,
  makeWrapper,
  pkg-config,
  python3,
  removeReferencesTo,
  fontconfig,
  libGL,
  libxkbcommon,
  wayland,
  bluez,
  systemd,
  wl-clipboard,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "hassmote";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "code.bas.es";
    owner = "marcus";
    repo = "hassmote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-poXQVDD09n5Oz0Uds35fqvsmgKlYU4J5gPQyaqhwfts=";
  };

  cargoHash = "sha256-BEHsHStfU3oqI6jZv/L9lUTwZcF7eus+Sm54CsdszVM=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m150-0.98.1";
          hash = "sha256-h/TFrGlqDur7bvIc9CBqDBwSJOQBk0N52/jwle3ay7c=";
        };
        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';

    SKIA_GN_COMMAND = lib.getExe gn;
    SKIA_NINJA_COMMAND = lib.getExe ninja;
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3 # skia
    removeReferencesTo
  ];

  buildInputs = [
    fontconfig
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    install -Dm444 -t $out/share/applications nix/hassmote.desktop
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps nix/hassmote.svg
  '';

  postFixup = ''
    # library skia embeds the path to its sources
    remove-references-to -t "$SKIA_SOURCE_DIR" $out/bin/hassmote
    wrapProgram $out/bin/hassmote \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      } \
      --prefix PATH : ${
        lib.makeBinPath [
          bluez
          systemd
          wl-clipboard
        ]
      }
  '';

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];

  meta = {
    description = "Apple TV remote backed by Home Assistant";
    homepage = "https://code.bas.es/marcus/hassmote";
    license = lib.licenses.mit;
    mainProgram = "hassmote";
    maintainers = with lib.maintainers; [ marcusramberg ];
    platforms = lib.platforms.linux;
  };
})
