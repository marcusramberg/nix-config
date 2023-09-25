{ pkgs, ... }: {
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
    gh = {
      enable = true;
      extensions = [ pkgs.gh-dash pkgs.gh-poi ];
      settings = {
        git_protocol = "ssh";
        # What editor gh should run when creating issues, pull requests, etc. If
        # blank, will refer to environment.
        editor =
          ""; # When to interactively prompt. This is a global config that cannot be

        # overridden by hostname. Supported values: enabled, disabled
        prompt = "enabled";
        # A pager program to send command output to, e.g. "
        pager = ""; # Aliases allow you to create nicknames for gh commands

        aliases = {
          co = "pr checkout";
          rev = "pr review";
          mkpr = "pr create --fill";
          # The path to a unix socket through which send HTTP connections. If
          # blank, HTTP traffic will be handled by net/http.DefaultTransport.
        };
        http_unix_socket = "";
        browser = "";
      };
    };
    # Smarter z
    zoxide.enable = true;
  };
}

