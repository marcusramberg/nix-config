_: {
  enable = true;
  settings = {
    scan_timeout = 10;
    # prompt
    format =
      "$directory$git_branch$git_metrics$nix_shell$cluster$package$character";
    add_newline = true;
    line_break.disabled = true;
    directory.style = "cyan";
    character = {
      success_symbol = "[❯](green)";
      error_symbol = "[❯](red)";
      vimcmd_symbol = "[❮](blue)";
      vimcmd_visual_symbol = "[❮](yellow)";
      vimcmd_replace_symbol = "[❮](red)";
      vimcmd_replace_one_symbol = "[❮](purple)";
    };
    # git
    git_branch = {
      style = "purple";
      symbol = "";
    };
    git_metrics = {
      disabled = false;
      added_style = "bold yellow";
      deleted_style = "bold red";
    };
    kubernetes = { disabled = false; };
    # package management
    package.format = "[$version](bold green) ";
    nix_shell.symbol = " ";
  };
}
