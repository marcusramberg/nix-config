{ pkgs, ... }:
let
  clipboard = ''
    {.keys = {KEY_LEFTMETA, KEY_V},
     .down_press = {KEY_LEFTSHIFT, KEY_RESERVED, KEY_INSERT, KEY_RESERVED},
     .up_press = {KEY_RESERVED, KEY_INSERT, KEY_RESERVED, KEY_LEFTSHIFT},
     DOWN_IFF_ALL_DOWN(2)},
    {
      .keys = {KEY_LEFTMETA, KEY_C},
      .down_press = {KEY_LEFTCTRL, KEY_RESERVED, KEY_INSERT, KEY_RESERVED},
      .up_press = {KEY_RESERVED, KEY_INSERT, KEY_RESERVED, KEY_LEFTCTRL},
      DOWN_IFF_ALL_DOWN(2)
    }
  '';
in
pkgs.stdenv.mkDerivation {
  name = "universal-clipboard";

  src = pkgs.fetchFromGitHub {
    owner = "zsugabubus";
    repo = "interception-k2k";
    rev = "5746bf39a321610bb6019781034f82e4c6e21e97";
    hash = "sha256-q2zlOvyW5jlasEIPVc+k6jh2wJZ7sUEpvXh/leH/hKw=";
  };
  patches = [ ./k2k-multi.patch ];

  configurePhase = ''
    mkdir -p ./in/uc
    echo "${clipboard}" > ./in/uc/multi-rules.h.in
  '';

  makeFlags = [
    "OUT_DIR=$(out)"
    "INSTALL_DIR=$(out)/bin"
    "CONFIG_DIR=./in"
  ];

  meta = {
    description = "Map cmd+c/v to shift/ctrl-insert for universal clipboard sharing";
    mainProgram = "uc";
  };
}
