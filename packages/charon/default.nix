{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  fetchurl,
  cmake,
  pkgconf,
  boost,
  fontconfig,
  freetype,
  kyotocabinet,
  libGL,
  libxkbcommon,
  marisa,
  openssl,
  protobuf,
  sqlite,
  wayland,
  zlib,
}:

rustPlatform.buildRustPackage (_: {
  pname = "charon";
  version = "1.10.0-unstable-2026-09-28";

  src = fetchFromSourcehut {
    owner = "~undeadleech";
    repo = "charon";
    rev = "cd9fb4fd9ebc973b10e488344420bc654a0d8909";
    fetchSubmodules = true;
    hash = "sha256-5cKC/0E10QBVFJIJy65eSvHwPJu+FLNCOONZHFA2xMM=";
  };

  cargoHash = "sha256-Yg7UBu6RcKZD8as2OTlPL5dfmaJrtixZfNWLFsfF0gE=";

  env = {
    # ponytail: prebuilt skia instead of a gn/ninja source build, so aarch64
    # only. The file name must track skia-bindings' version and features in
    # Cargo.lock/Cargo.toml; see neovide in nixpkgs for the source build.
    SKIA_BINARIES_URL = "file://${
      fetchurl {
        url = "https://github.com/rust-skia/skia-binaries/releases/download/0.153.3/skia-binaries-b7f043e0b1e2a850e702-aarch64-unknown-linux-gnu-egl-ganesh-gl-jpegd-jpege-pdf-skottie-svg-textlayout-vulkan-wayland-webpd-webpe-x11.tar.gz";
        hash = "sha256-55HA5sEioaBc1yo5qcW5g5V6xRkgV1uYkLuBwJAdFUA=";
      }
    }";

    # The build script curls these otherwise. Both URLs are mutable, so the
    # hashes go stale whenever upstream regenerates the indexes.
    TILE_METADATA_PATH = fetchurl {
      url = "https://catacombing.org/tiles/size";
      hash = "sha256-umyTrLbT/Y1q4sy5z1ljaiFbZTMdYliMUqqewYI4i+0=";
    };
    MODRANA_DATA_PATH = fetchurl {
      url = "https://data.modrana.org/osm_scout_server/countries_provided.json";
      hash = "sha256-dw5sWZz7QtTzXL6Le1vgKV2uRdLSXr6TzjzMnCPso2I=";
    };
  };

  # cmake is only for the valhalla crate's build script, which also needs
  # pkgconf's --with-path
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkgconf
    protobuf
  ];

  buildInputs = [
    boost
    fontconfig
    freetype
    kyotocabinet
    libGL
    libxkbcommon
    marisa
    openssl
    protobuf
    sqlite
    wayland
    zlib
  ];

  # Skip render_offline_tiles, which would build maplibre-native
  cargoBuildFlags = [
    "--package"
    "charon"
  ];
  doCheck = false;

  postInstall = ''
    install -Dm644 -t $out/share/applications charon.desktop
    install -Dm644 -t $out/share/metainfo org.catacombing.charon.metainfo.xml
    install -Dm644 logo.svg $out/share/icons/hicolor/scalable/apps/Charon.svg
    install -Dm644 rules/66-charon.rules.polkit $out/share/polkit-1/rules.d/66-charon.rules
    substituteInPlace $out/share/polkit-1/rules.d/66-charon.rules --replace-fail catacomb users
  '';

  # dlopened
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
      ]
    } $out/bin/charon
  '';

  meta = {
    description = "Wayland mobile maps and navigation";
    homepage = "https://git.sr.ht/~undeadleech/charon";
    license = lib.licenses.gpl3Only;
    mainProgram = "charon";
    maintainers = with lib.maintainers; [ marcusramberg ];
    platforms = [ "aarch64-linux" ];
  };
})
