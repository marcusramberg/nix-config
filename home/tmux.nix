{ pkgs, inputs, ... }:
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
      nord
      tmux-thumbs
      tmux-fzf
      inputs.test.legacyPackages.aarch64-darwin.pkgs.tmuxPlugins.fingers
      inputs.test.legacyPackages.aarch64-darwin.pkgs.tmuxPlugins.fuzzback
      tmux-thumbs
      # tmux-fzf
      tilish
    ];
    prefix = "`";
    secureSocket = false; # survives user logout
    terminal = "tmux-256color";
    tmuxinator.enable = true;

    extraConfig = "${pkgs.lib.readFile ../config/tmux.conf}";
  };
}
