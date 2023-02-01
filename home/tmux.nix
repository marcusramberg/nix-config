{ pkgs, ... }:
{
  aggressiveResize = true;
  baseIndex = 1;
  clock24 = true;
  enable = true;
  keyMode = "vi";
  plugins = [ pkgs.tmuxPlugins.nord pkgs.tmuxPlugins.tmux-thumbs ];
  prefix = "`";
  secureSocket = false; # survives user logout
  terminal = "tmux-256color";
  tmuxinator.enable = true;
  extraConfig = ''
    set -ga terminal-overrides ",*256col*:Tc"
    set -g set-titles on
    set -g set-titles-string "#I > #T"
    set -g status-style bg=white,fg=black
    set -g mode-style bg=white,fg=black
    set -g message-style bg=white,fg=black
    set -g message-command-style bg=white,fg=black
    # set -g status off
    set -g display-time 1000
    set-window-option -g visual-bell on
    set-window-option -g bell-action other
  '';
}
