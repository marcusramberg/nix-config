{
  config,
  lib,
  pkgs,
  ...
}:
let
  kernel = config.boot.kernelPackages.kernel;
  asahiPkgs = config.hardware.asahi.pkgs;

  src = pkgs.fetchFromGitHub {
    owner = "joshuaswarren";
    repo = "omarchy-ane";
    rev = "b09d8cf4b6aac117ed3263edab878958fd2d7374";
    hash = "sha256-Zc1hlSNXSb70U1Q0DiboibFZ9v0U7hyCDiqekXL3kMw=";
  };

  module = pkgs.stdenv.mkDerivation {
    pname = "ane-t6021";
    version = "0-unstable-2026-11-18";
    inherit src;
    nativeBuildInputs = kernel.moduleBuildDependencies;
    makeFlags = kernel.commonMakeFlags ++ [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(PWD)/ane/t6021"
      "ANE_VERSION=${lib.substring 0 7 src.rev}"
      "INSTALL_MOD_PATH=${placeholder "out"}"
      "DEPMOD=true"
    ];
    buildFlags = [ "modules" ];
    # kbuild's own install signs the module; aggregateModules needs the .cer
    installTargets = [ "modules_install" ];
  };

  # Apple's firmware, pulled from the macOS 13.5 IPSW by upstream's own
  # fetcher. The pin only applies to a 13.5 stub (asahi,os-fw-version).
  firmwareBlob =
    pkgs.runCommand "t602x_ane0_fw_selene_rc4x.macho"
      {
        nativeBuildInputs = [ pkgs.python3 ];
        NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = "a9c4b771294a6b115624d9480a6248d0899a1681a575e865070b87a3248427bc";
      }
      ''
        python3 - <<'EOF'
        import os, runpy
        m = runpy.run_path("${src}/packaging/omarchy-ane-firmware-fetch")
        member, _, size, sha256, version = m["SELENE"]
        data = m["im4p_payload"](m["fetch_member"](m["IPSW"][version], member))
        m["verify"](data, size, sha256)
        open(os.environ["out"], "wb").write(data)
        EOF
      '';

  firmware = pkgs.runCommand "ane-firmware" { } ''
    install -Dm644 ${firmwareBlob} $out/lib/firmware/apple/ane/t602x_ane0_fw_selene_rc4x.macho
  '';

  # Same recipe as apple-silicon-support's boot-m1n1, with the ANE overlay
  # applied to this board's device tree.
  bootBin =
    let
      m1n1 = config.boot.m1n1Package;
      uboot = asahiPkgs.uboot-asahi.override {
        inherit m1n1;
        linux-asahi = config.boot.kernelPackages;
      };
    in
    pkgs.runCommand "boot-ane.bin" { nativeBuildInputs = [ pkgs.dtc ]; } ''
      dtc -@ -I dts -O dtb -o ane.dtbo ${src}/packaging/dt/t6022-ane.dts
      mkdir dtbs
      cp --no-preserve=mode ${kernel}/dtbs/apple/*.dtb dtbs/
      fdtoverlay -i ${kernel}/dtbs/apple/t6022-j475d.dtb -o dtbs/t6022-j475d.dtb ane.dtbo
      cat ${m1n1}/lib/m1n1/m1n1.bin dtbs/*.dtb ${uboot}/u-boot-nodtb.bin.gz > $out
    '';
in
{
  boot.extraModulePackages = [ module ];
  # Research driver: load by hand (modprobe ane_t6021) until it has proven
  # itself on this machine.
  boot.blacklistedKernelModules = [ "ane_t6021" ];
  hardware.firmware = [ firmware ];

  # boot.bin is shared by every generation, so a bad device tree cannot be
  # rolled back from the boot menu. Recovery: from macOS/recoveryOS copy
  # m1n1/boot-stock.bin over m1n1/boot.bin on the EFI partition.
  boot.loader.systemd-boot.extraFiles = {
    "m1n1/boot.bin" = lib.mkForce bootBin;
    "m1n1/boot-stock.bin" = config.system.build.m1n1;
  };
}
