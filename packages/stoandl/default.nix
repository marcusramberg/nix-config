{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
  jdk25,
  makeWrapper,
}:
let
  # Gradle's own JVM. Not the toolchain the Kotlin compiler targets.
  gradle = gradle_8.override { java = jdk21; };

  # Pinned to the commit the `libs/libpebble3` submodule points at in `src`
  # below; bump both together.
  libpebble3 = fetchFromGitHub {
    owner = "yoxcu";
    repo = "libpebble3";
    rev = "2749f7c5104c75ca635baad00595ebbe99d4c552";
    hash = "sha256-29iTvefWMZ6UWTULYYRQEOZ2IhmvbaY5v+DWyF1ICss=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stoandl";
  version = "0-unstable-2026-11-17";

  # Head of yoxcu/stoandl#4 (Rebble store), three commits on top of main.
  src = fetchFromGitHub {
    owner = "yoxcu";
    repo = "stoandl";
    rev = "66877aae67d9abbbb70779f63852babc785cb848";
    hash = "sha256-+PB+Sf07fTY6HQZjYSbBOqCQkR9Xn8ZcHIA8OlLAuig=";
  };

  postPatch = ''
    # The composite build's source, normally a submodule.
    rm -rf libs/libpebble3
    cp -r ${libpebble3} libs/libpebble3
    chmod -R u+w libs/libpebble3

    # Fix version in sandbox
    substituteInPlace build.gradle.kts \
      --replace-fail '"0.1.0-nogit"' '"${finalAttrs.version}"'

    # fix jvm path
    substituteInPlace gradle.properties \
      --replace-fail \
        'org.gradle.java.installations.paths=/usr/lib/jvm/java-17-openjdk,/usr/lib/jvm/java-21-openjdk' \
        ""
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  # The dependency lock for the Gradle build. Regenerate after bumping `src`
  # or `libpebble3` with:
  #
  #   nix run .#pkgs.stoandl.mitmCache.updateScript
  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    # Where `jvmToolchain(25)` finds its JDK.
    "-Porg.gradle.java.installations.paths=${jdk25.home}"
    # And never try to download one;
    "-Porg.gradle.java.installations.auto-download=false"
  ];

  gradleBuildTask = "shadowJar";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/stoandl-*-all.jar \
      "$out/share/java/stoandl/stoandl.jar"

    makeWrapper ${lib.getExe' jdk25 "java"} "$out/bin/stoandld" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-jar $out/share/java/stoandl/stoandl.jar"

    makeWrapper ${lib.getExe' jdk25 "java"} "$out/bin/stoandl" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-jar $out/share/java/stoandl/stoandl.jar" \
      --add-flags "ctl"

    install -Dm644 packaging/stoandl.conf.example -t "$out/share/doc/stoandl"
    install -Dm644 README.md -t "$out/share/doc/stoandl"

    runHook postInstall
  '';

  meta = {
    description = "Headless Pebble smartwatch companion daemon for Linux";
    homepage = "https://github.com/yoxcu/stoandl";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "stoandl";
  };
})
