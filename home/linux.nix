{ lib, pkgs, osConfig, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
in {
  programs = mkIf osConfig.services.xserver.enable {
    chromium.enable = true;
    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        # See nixpkgs' firefox/wrapper.nix to check which options you can use
        cfg = {
          # Tridactyl native connector
          enableTridactylNative = true;
        };
      };
    };
  };
  services.gpg-agent = mkIf stdenv.isLinux {
    enable = pkgs.stdenv.isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}