{ pkgs, ... }:
{
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
          init.defaultBranch = "main";
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
          submodule.recurse = true;
        };
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_rsa.pub";
        url = {
          "git@github.com:".insteadOf = "gh:";
          "git@github.com:reMarkable/cloud".insteadOf = "https://github.com/reMarkable/cloud";
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        log.follow = true;
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
