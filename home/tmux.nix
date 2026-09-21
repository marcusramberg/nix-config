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
        plugin = tokyo-night-tmux;
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
    # tmux-256color advertises colors#0x100, and ncurses apps decide on 24-bit
    # support from that count (not $COLORTERM) - neomutt's theme then fails to
    # source. xterm-direct is the same entry with colors#0x1000000; tmux still
    # translates for outer terminals without the RGB override below.
    terminal = "xterm-direct";
    tmuxinator.enable = true;
    extraConfig = "${pkgs.lib.readFile ../config/tmux.conf}";
  };
}
