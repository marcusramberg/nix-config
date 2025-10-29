{
  inputs,
  lib,
  user,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  flakePath =
    if isNixOS then
      "/etc/nixos"
    else if pkgs.stdenv.isDarwin then
      "/Users/${user}/.config/nix-darwin"
    else
      "/home/${user}/.config/nix-config";
in
{
  home.file = {
    ".config/wezterm" = {
      source = ../config/wezterm;
      recursive = true;
    };
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/ghostty";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/fastfetch";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hypr";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/waybar";
    ".config/tmuxinator" = {
      source = ../config/tmuxinator;
      recursive = true;
    };
    "/.config/fish/themes/Catppuccin Mocha.theme".source = ./catppuccin-mocha-fish-theme;
    ".config/nimdow/status".source = ../config/nimdow_status;
    ".config/nimdow/config.toml".text = inputs.nix-std.lib.serde.toTOML (
      import ../config/nimdow.nix {
        inherit pkgs;
        inherit osConfig;
      }
    );
    ".config/rofi" = {
      source = ../config/rofi;
      recursive = true;
    };

    ".i3/config".source = ../config/i3-config${lib.optionalString isNixOS "-ghost"};
    ".ripgreprc".source = ../config/ripgreprc;
    ".amethyst.yml".source = ../config/amethyst.yml;
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    ".config/karabiner/karabiner.json".source = ../config/karabiner.json;
    ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/hammerspoon";
    ".aerospace.toml".source = ../config/aerospace.toml;
  };
}
