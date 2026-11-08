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
  # fjordxy generates its own niri and ghostty config.
  isFjordxy = (osConfig.profiles.desktop.shell or "dux") == "fjordxy";
in
{
  # Leftover dms-era dir symlinks would make HM write fjordxy's files through into the repo.
  home.activation.dropRepoConfigLinks = lib.mkIf isFjordxy (
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      for d in niri ghostty; do
        p="${config.home.homeDirectory}/.config/$d"
        if [[ -L "$p" && "$(readlink -f "$p")" == "${flakePath}/"* ]]; then
          run rm "$p"
        fi
      done
    ''
  );

  home.file = {
    ".config/wezterm" = {
      source = ../config/wezterm;
      recursive = true;
    };
    ".config/DankMaterialShell".source =
      config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/DankMaterialShell";
    ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/mango";
    ".config/niri" = lib.mkIf (!isFjordxy) {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/niri";
    };
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/nvim";
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/foot";
    ".config/ghostty" = lib.mkIf (!isFjordxy) {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/config/ghostty";
    };
    ".config/tmuxinator" = {
      source = ../config/tmuxinator;
      recursive = true;
    };
    "/.config/fish/themes/nord.theme".source = ../config/fish/nord.theme;
    ".ripgreprc".source = ../config/ripgreprc;
    ".config/direnv/direnv.toml".source = ../config/direnv/direnv.toml;
  };
}
