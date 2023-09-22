{ std, ... }: {
  ".config/wezterm" = {
    source = ../config/wezterm;
    recursive = true;
  };
  ".config/nvim" = {
    source = ../config/nvim;
    recursive = true;
  };
  ".doom.d" = {
    source = ../config/doom.d;
    recursive = true;
  };
  ".config/nimdow/status".source = ../config/nimdow;
  ".config/nimdow/config.toml".text = std.serde.toTOML (import ./nimdow.nix);
  ".config/rofi" = {
    source = ../config/rofi;
    recursive = true;
  };

  ".amethyst.yml".source = ../config/amethyst.yml;
  ".config/bat/config".source = ../config/bat/config;
  ".config/btop/btop.config".source = ../config/btop.conf;
  ".config/gh/config.yml".source = ../config/gh/config.yml;
  ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
  ".gitconfig".source = ../config/gitconfig;
  ".i3/config".source = ../config/i3-config;
  ".ripgreprc".source = ../config/ripgreprc;
  # ".config/starship.toml".source = ../config/starship.toml;
}

