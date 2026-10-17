{
  lib,
  symlinkJoin,
  makeDesktopItem,
  writeShellScript,
  runCommand,
  fetchurl,
  python3,
  libnotify,
  coreutils,
  uidFile ? "/run/agenix/hackeriet-door",
}:
let
  icon = fetchurl {
    url = "https://hackeriet.no/comotion-sjn-transparent-1.2.svg";
    hash = "sha256-kvNwJKE6DyGg+wechBSDI80XkVetTWYgtccK7bz/xrc=";
  };
  # Holding the CLF in listen mode blocks tag reading, hence the timeout.
  run = writeShellScript "nfc-badge" ''
    ${libnotify}/bin/notify-send -i nfc-badge "NFC badge" "Presenting your card for 30 seconds"
    if err=$(${coreutils}/bin/timeout 30 ${python3}/bin/python3 ${./nfc-emulate.py} \
      --uid "$(${coreutils}/bin/cat ${uidFile})" 2>&1 >/dev/null) || [ $? -eq 124 ]; then
      ${libnotify}/bin/notify-send -i nfc-badge "NFC badge" "Stopped"
    else
      ${libnotify}/bin/notify-send -u critical -i nfc-badge "NFC badge" "Failed: ''${err##*$'\n'}"
    fi
  '';
in
symlinkJoin {
  name = "nfc-badge";
  paths = [
    (makeDesktopItem {
      name = "nfc-badge";
      desktopName = "NFC Badge";
      comment = "Present the phone as an NFC card for 30 seconds";
      exec = "${run}";
      icon = "nfc-badge";
      terminal = false;
      categories = [ "Utility" ];
    })
    (runCommand "nfc-badge-icon" { } ''
      install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/nfc-badge.svg
    '')
  ];
  meta = {
    description = "Present the Fairphone 5 (ST21NFCD) as a fixed-UID NFC-A tag";
    platforms = lib.platforms.linux;
  };
}
