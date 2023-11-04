{ lib, pkgs, osConfig, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
in {
  programs = mkIf (builtins.hasAttr "xserver" osConfig.services) {
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
  gtk = mkIf (builtins.hasAttr "xserver" osConfig.services) {
    enable = true;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
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
