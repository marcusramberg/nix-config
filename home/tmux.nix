{ pkgs, ... }: {
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
  extraConfig = "${pkgs.lib.readFile ../config/tmux.conf}";
}
