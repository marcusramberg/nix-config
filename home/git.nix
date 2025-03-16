{ pkgs, ... }:
{
  home.packages = with pkgs; [
    delta
    git-crypt
    git-extras
    git-lfs
    git-recent
    gitAndTools.gh
    git
    lazygit
    pre-commit
    revup
    stgit
    # git-stack
  ];
  programs = {
    gh = {
      enable = true;
      extensions = [
        pkgs.gh-dash
        pkgs.gh-poi
        pkgs.gh-tidy
        pkgs.gh-copilot
      ];
      settings = {
        git_protocol = "ssh";
        # What editor gh should run when creating issues, pull requests, etc. If
        # blank, will refer to environment.
        editor = "";
        # When to interactively prompt. This is a global config that cannt be
        # overridden by hostname. Supported values: enabled, disabled
        prompt = "enabled";
        # A pager program to send command output to, e.g. "
        pager = "";

        # Aliases allow you to create nicknames for gh commands
        aliases = {
          co = "pr checkout";
          cg = "copilot suggest -t git";
          cc = "copilot suggest -t shell";
          cgh = "copilot suggest -t gh";
          ce = "copilot explain";
          rev = "pr review";
          mkpr = "pr create --fill";
        };
        # The path to a unix socket through which send HTTP connections. If
        # blank, HTTP traffic will be handled by net/http.DefaultTransport.
        http_unix_socket = "";
        browser = "";
        version = 1;
      };
    };

    git = {
      enable = true;
      aliases = {

        patch = "!git diff --no-ext-diff --no-color";
        # rank-contributers = !$ZSH/bin/git-rank-contributers
        count = "!git shortlog -sn";
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        df = "diff";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        retrack = ''!retrack() { git config "branch.$1.remote" $(dirname "$2"); git config  "branch.$1.merge" "refs/heads/$(basename "$2")"; }; retrack'';
        ca = "commit --amend --reuse-message=HEAD";
        edit = "!vim `git ls-files -m ` -p ";
        credit = "blame";
        # git stack
        next = "stack next";
        prev = "stack previous";
        reword = "stack reword";
        amend = "stack amend";
        sync = "stack sync";
        run = "stack run";
      };
      difftastic = {
        background = "dark";
        display = "inline";
        enable = true;
      };
      extraConfig = {
        core = {
          whitespace = "trailing-space,space-before-tab";
          excludesfile = "~/.gitignore_global";
        };
        color = {
          branch = {
            current = "yellow reverse";
            local = "yellow";
            remote = "green";
          };
          status = {
            added = "yellow";
            changed = "green";
            untracked = "cyan";
          };
        };
        commit.gpgsign = true;
        format.signOff = true;
        gpg.format = "ssh";
        init.defaultBranch = "main";
        log.follow = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        submodule.recurse = true;
        user.signingkey = "~/.ssh/id_rsa.pub";
        url = {
          "git@github.com:".insteadOf = "gh:";
          "git@github.com:reMarkable/cloud".insteadOf = "https://github.com/reMarkable/cloud";
        };
      };
      includes = [
        {
          condition = "gitdir:~/Source/reMarkable/";
          path = "~/.gitconfig.remarkable";
        }
      ];
      lfs.enable = true;
      userEmail = "marcus@means.no";
      userName = "Marcus Ramberg";
    };
  };
}
