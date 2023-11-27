{ lib, pkgs, osConfig, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = isNixOS && osConfig.services.xserver.enable;

in {

  gtk = mkIf isDesktop {
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
