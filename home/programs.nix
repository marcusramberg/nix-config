{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  programs = {
    atuin = {
      daemon.enable = true;
      enable = true;
      # enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://atuin.means.no";
        search_mode = "fuzzy";
        keymap_mode = "vim-insert";
        update_check = "false";
        ctrl_n_shortcuts = "true";
        style = "compact";
      };

    };
    bat = {
      enable = true;
      config = {
        theme = "Nord";
        map-syntax = ".ignore:Git Ignore";
        style = "changes";
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "nord";
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
      extraOptions = [
        "--group-directories-first"
        "--group"
        "--smart-group"
      ];
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
    rbw = {
      enable = true;
      settings = {
        base_url = "https://passwords.means.no/";
        email = "marcus@means.no";
        pinentry = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          forwardAgent = true;
        };
        "mouse1" = {
          proxyJump = "mcbuildface.stig.io";
        };
        "mouse2" = {
          proxyJump = "mcbuildface.stig.io";
        };
      }
      // lib.optionalAttrs isDarwin {
        "*".extraOptions.IdentityAgent =
          "/Users/marcus/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
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
