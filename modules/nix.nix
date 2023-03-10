{ config, pkgs, ... }: {
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.floxdev.com"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "flox-store-public-0:8c/B+kjIaQ+BloCmNkRUKwaVPFWkriSAd0JJvuDu4F0="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "marcus" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      # interval = "weekly";
      options = "--delete-older-than 30d";

    };

    extraOptions = ''
      !include ${config.age.secrets.nixAccessTokens.path}
    '' + pkgs.lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };
}
