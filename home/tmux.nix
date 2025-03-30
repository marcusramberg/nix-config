{ pkgs, ... }:
{
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    enable = true;
    # Instant esc
    escapeTime = 0;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
        '';
      }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-osc52 1
        '';
      }
      tmux-fzf
    ];
    prefix = "`";
    secureSocket = false; # survives user logout
    terminal = "tmux-256color";
    tmuxinator.enable = true;
    extraConfig = "${pkgs.lib.readFile ../config/tmux.conf}";
  };
}
