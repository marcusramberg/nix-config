{ pkgs, ... }:
{
  ".config/wezterm" = { source = ./files/config/wezterm; recursive = true; };
  ".config/nvim" = { source = ./files/config/nvim; recursive = true; };

  ".config/fish/tide_config.fish".source = ./files/config/fish/tide_config.fish;
  ".config/bat/config".source = ./files/config/bat/config;
  ".config/gh/config.yml".source = ./files/config/gh/config.yml;
  ".i3/config".source = ./files/i3-config;
  ".ripgreprc".source = ./files/ripgreprc;
  ".gitconfig".source = ./files/gitconfig;
}

