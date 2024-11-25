{
  std,
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
  home.file =
    {
      ".config/wezterm" = {
        source = ../config/wezterm;
        recursive = true;
      };
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
      ".config/hypr" = {
        source = ../config/hypr;
        recursive = true;
      };
      ".config/waybar" = {
        source = ../config/waybar;
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
      ".config/nimdow/config.toml".text = std.serde.toTOML (
        import ../config/nimdow.nix {
          inherit pkgs;
          inherit osConfig;
        }
      );
      ".config/rofi" = {
        source = ../config/rofi;
        recursive = true;
      };

      ".config/btop/btop.conf".source = ../config/btop.conf;
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
