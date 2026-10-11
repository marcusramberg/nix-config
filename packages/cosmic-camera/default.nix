{
  lib,
  glib,
  gst_all_1,
  rustPlatform,
  fetchFromGitHub,
  libc,
  libcamera,
  libcosmicAppHook,
  llvmPackages,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-camera";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-camera";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2qOj5+OwRasm9T/NF89viiPLXXzU5G/f7qA+6IWdtZk";
  };

  cargoHash = "sha256-0jAmUv7b2HncE/aeIC64OH2y/aTCLcqHPCZW3M0168k=";

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  # bindgen's libclang does not see stdenv's include flags, so point it at the
  # glibc headers explicitly (otherwise C headers like sys/types.h are "not found").
  env.BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${libc.dev}/include";
  nativeBuildInputs = [ libcosmicAppHook ];
  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base.dev
    libcamera
  ];

  postInstall = ''
    wrapProgram $out/bin/cosmic-camera \
      --prefix LD_LIBRARY_PATH : ${libcosmicAppHook}/lib
  '';

  meta = {
    description = "Cosmic Camera";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-camera";
    maintainers = with lib.maintainers; [ marcusramberg ];
  };
})
