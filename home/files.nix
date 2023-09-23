{ std, pkgs, osConfig, ... }: {
  home.file = {
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
    ".config/nimdow/status".source = ../config/nimdow_status;
    ".config/nimdow/config.toml".text = std.serde.toTOML
      (import ../config/nimdow.nix {
        inherit pkgs;
        inherit osConfig;
      });
    ".config/rofi" = {
      source = ../config/rofi;
      recursive = true;
    };

    ".amethyst.yml".source = ../config/amethyst.yml;
    ".config/bat/config".source = ../config/bat/config;
    ".config/btop/btop.config".source = ../config/btop.conf;
    ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
    ".gitconfig".source = ../config/gitconfig;
    ".i3/config".source = ../config/i3-config;
    ".ripgreprc".source = ../config/ripgreprc;
  };
}

