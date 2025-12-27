{
  lib,
  user,
  config,
  osConfig,
  ...
}:
let
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  flakePath = if isNixOS then "/etc/nixos" else "/home/${user}/.config/nix-config";
in
{
  home.file = {
    ".config/wezterm" = {
      source = ../config/wezterm;
      recursive = true;
    };
    ".config/DankMaterialShell".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/DankMaterialShell";
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/niri";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/ghostty";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/fastfetch";
    ".config/tmuxinator" = {
      source = ../config/tmuxinator;
      recursive = true;
    };
    "/.config/fish/themes/nord.theme".source = ../config/fish/nord.theme;
    ".ripgrep/ripgreprc".source = ../config/ripgreprc;
    ".config/direnv/direnv.toml".source = ../config/direnv/direnv.toml;
  };
}
