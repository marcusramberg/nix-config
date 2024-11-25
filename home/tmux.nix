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
      catppuccin
      tmux-thumbs
      tmux-fzf
      tilish
    ];
    prefix = "`";
    secureSocket = false; # survives user logout
    terminal = "tmux-256color";
    tmuxinator.enable = true;

    extraConfig = "${pkgs.lib.readFile ../config/tmux.conf}";
  };
}
