{ pkgs, ... }:
{
  programs = {
    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
    };
    bat = {
      enable = true;
      config = {
        theme = "Catppuccin-mocha";
        map-syntax = ".ignore:Git Ignore";
        style = "numbers,changes";
      };
      themes = {
        Catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
          file = "Catppuccin-mocha.tmTheme";
        };
      };
    };
    programs.btop = {
      enable = true;

      catppuccin = {
        enable = true;
        flavor = "mocha";
      };

      settings = {
        theme_background = true; # make btop solid so we can overwrite the theme
      };
    };
    bottom.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    helix = {
      enable = true;
    };
    home-manager.enable = true;
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    keychain.enable = true;
    # navi.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    neovim = {
      extraConfig = ":luafile ~/.config/nvim/init.lua";
      viAlias = true;
      vimAlias = true;
    };
    rbw = {
      enable = true;
      settings = {
        base_url = "https://passwords.means.no/";
        email = "marcus@means.no";
        pinentry = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry;
      };
    };
    ssh = {
      enable = true;
      controlMaster = "auto";
    };
    # Smarter z
    zoxide.enable = true;
  };
}
