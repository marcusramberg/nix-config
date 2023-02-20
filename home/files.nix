{ pkgs, ... }:
{
  ".config/wezterm" = { source = ../config/wezterm; recursive = true; };
  ".config/nvim" = { source = ../config/nvim; recursive = true; };

  ".config/bat/config".source = ../config/bat/config;
  ".config/btop/btop.config".source = ../config/btop.conf;
  ".config/fish/tide_config.fish".source = ../config/fish/tide_config.fish;
  ".config/gh/config.yml".source = ../config/gh/config.yml;
  ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
  ".gitconfig".source = ../config/gitconfig;
  ".i3/config".source = ../config/i3-config;
  ".ripgreprc".source = ../config/ripgreprc;
}

