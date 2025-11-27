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
      package = pkgs.nixVersions.nix_2_31;
      distributedBuilds = true;
      settings = {
        download-buffer-size = 500000000;
        substituters = [
          "https://cache.bas.es/bases"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
          "https://marcusramberg.cachix.org"
          "https://jovian-nixos.cachix.org"

        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "marcusramberg.cachix.org-1:3gZte6tgsUkcVSgkKaoXtQQQMixtEbpEl+xqIkB9TSY="
          "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
          "bases:bg7mtzwSME8dI+IXhYLzDTQ4TzY4zMmIzyeqjgR5Isg="
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
