{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;

in
{
  services = {
    gpg-agent = mkIf stdenv.isLinux {
      enable = pkgs.stdenv.isLinux;

      # cache the keys forever so we don't get asked for a password
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };
    ssh-tpm-agent = mkIf stdenv.isLinux {
      enable = true;
    };
    ssh-agent = mkIf stdenv.isLinux {
      enable = true;
    };
  };

}
