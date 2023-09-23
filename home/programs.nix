_: {
  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
      git = true;
    };
    git.difftastic = {
      background = "dark";
      display = "inline";
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    keychain.enable = true;
    # navi.enable = true;
    nix-index.enable = true;
    neovim.extraConfig = ''
      :luafile ~/.config/nvim/init.lua 
    '';
    # Smarter z
    zoxide.enable = true;
  };
}
