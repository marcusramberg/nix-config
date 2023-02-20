{ pkgs, ... }:
{
  ".config/wezterm" = { source = ../config/wezterm; recursive = true; };
  ".config/nvim" = { source = ../config/nvim; recursive = true; };
  ".doom.d" = { source = ../config/doom.d; recursive = true; };

  ".config/fish/tide_config.fish".source = ../config/fish/tide_config.fish;
  ".config/bat/config".source = ../config/bat/config;
  ".config/gh/config.yml".source = ../config/gh/config.yml;
  ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
  ".i3/config".source = ../config/i3-config;
  ".ripgreprc".source = ../config/ripgreprc;
  ".gitconfig".source = ../config/gitconfig;
}

