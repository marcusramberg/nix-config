{ config, pkgs, ... }:
{
  settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://cache.floxdev.com"
    ];
    trusted-public-keys = [
      "flox-store-public-0:8c/B+kjIaQ+BloCmNkRUKwaVPFWkriSAd0JJvuDu4F0="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "marcus" ];
    auto-optimise-store = true;
  };
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";

  };


  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
