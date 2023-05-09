_: {
  enable = true;
  settings = {
    scan_timeout = 50;
    # prompt
    # format =
    #   "$directory$git_branch$git_metrics$nix_shell$cluster$package$character";
    add_newline = false;
    line_break.disabled = false;
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
    kubernetes = {
      disabled = false;
      style = "bold blue";
      format = "[$context/$namespace](bold blue) ";
    };

    gcloud = {
      disabled = true;
      style = "bold purple";
      format = "[ $symbol$active ] ($style) ";

    };

    memory_usage.disabled = true;
    # package management
    #package.format = "[$version](bold green) ";
    package.format = "";
    nix_shell.symbol = " ";

  };
}
