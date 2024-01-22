{ std, lib, config, pkgs, osConfig, ... }:
let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  flakePath =
    if isNixOS then "/etc/nixos" else "/Users/marcus/.config/nix-darwin";
in {
  home.file = {
    ".config/wezterm" = {
      source = ../config/wezterm;
      recursive = true;
    };
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
    ".config/hypr" = {
      source = ../config/hypr;
      recursive = true;
    };
    ".config/tmuxinator" = {
      source = ../config/tmuxinator;
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

    ".config/bat/config".source = ../config/bat/config;
    ".config/btop/btop.conf".source = ../config/btop.conf;
    ".gitconfig".source = ../config/gitconfig;
    ".i3/config".source = ../config/i3-config;
    ".ripgreprc".source = ../config/ripgreprc;
    # TODO: These should only be installed on macOS
    ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
    ".hammerspoon".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hammerspoon";
    ".amethyst.yml".source = ../config/amethyst.yml;
  };
}

