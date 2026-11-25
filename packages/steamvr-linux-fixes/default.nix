{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  vulkan-loader,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "steamvr-linux-fixes";
  version = "0.2.1";

  # Prebuilt release: building from source is awkward in the sandbox because
  # the vendored funchook FetchContent-downloads capstone at configure time.
  src = fetchurl {
    url = "https://github.com/BnuuySolutions/SteamVRLinuxFixes/releases/download/v${finalAttrs.version}/VK_LAYER_BNUUY_steamvr_linux_fixes.zip";
    hash = "sha256-r2SaWqRbcyqimYnEAdI9kIjwE8EFwdlIk9dxkq3bbQU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];
  buildInputs = [
    vulkan-loader
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 libsteamvr_linux_fixes.so $out/lib/libsteamvr_linux_fixes.so
    install -Dm644 VkLayer_steamvr_linux_fixes.json \
      $out/share/vulkan/implicit_layer.d/VkLayer_steamvr_linux_fixes.json
    # The manifest ships a prefix-relative library_path; point it at the store
    substituteInPlace $out/share/vulkan/implicit_layer.d/VkLayer_steamvr_linux_fixes.json \
      --replace-fail "../../../lib/libsteamvr_linux_fixes.so" "$out/lib/libsteamvr_linux_fixes.so"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Vulkan layer that patches SteamVR's vrcompositor for wired headsets (refresh rate unlock, present-wait latency fix)";
    homepage = "https://github.com/BnuuySolutions/SteamVRLinuxFixes";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
