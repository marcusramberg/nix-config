{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    age.secrets.nixAccessTokens = {
      group = "wheel";
      mode = "0440";
    };
    nix = {
      channel.enable = false;
      package = pkgs.lix;
      distributedBuilds = true;
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.floxdev.com"
          "https://nixhelm.cachix.org"
          "https://devenv.cachix.org"
          "https://ghostty.cachix.org"
          "https://colmena.cachix.org"
          "https://marcusramberg.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "flox-store-public-0:8c/B+kjIaQ+BloCmNkRUKwaVPFWkriSAd0JJvuDu4F0="
          "nixhelm.cachix.org-1:esqauAsR4opRF0UsGrA6H3gD21OrzMnBBYvJXeddjtY="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
          "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
          "marcusramberg.cachix.org-1:3gZte6tgsUkcVSgkKaoXtQQQMixtEbpEl+xqIkB9TSY="
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "marcus"
          "arne"
        ];
        auto-optimise-store = lib.mkDefault true;
      };
      gc = {
        automatic = true;
        # interval = "weekly";
        options = "--delete-older-than 30d";

      };

      extraOptions = ''
        !include ${config.age.secrets.nixAccessTokens.path}
      '';
    };
  };
}
