{ pkgs, ... }:
{
  programs = {
    atuin = {

      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.means.no";
        search_mode = "prefix";
      };

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
    btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        truecolor = "True";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    home-manager.enable = true;
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    keychain.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    neovim = {
      extraConfig = ":luafile ~/.config/nvim/init.lua";
      viAlias = true;
      vimAlias = true;
    };
    pay-respects = {
      enable = true;
      enableFishIntegration = true;
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
      addKeysToAgent = "yes";
      forwardAgent = true;
      matchBlocks."10.8.20.128".forwardX11 = true;
    };
    # Smarter z
    zoxide.enable = true;
  };
  xdg.configFile = {
    "btop/themes/catppuccin_latte.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54/themes/catppuccin_latte.theme";
      hash = "sha256-Dp/4A4USHAri+QgIM/dJFQyLSR6KlWtMc7aYlFgmHr0=";
    };
    "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54/themes/catppuccin_mocha.theme";
      hash = "sha256-KnXUnp2sAolP7XOpNhX2g8m26josrqfTycPIBifS90Y=";
    };
  };
}
