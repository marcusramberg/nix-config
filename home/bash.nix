_: {
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        gc = "git commit";
        gs = "git status";
        gsu = "git status -uno";
        gp = "git pull";
        gb = "git branch";
        gd = "git diff";
        gwa = "git worktree add";
        gwl = "git worktree list";
        gwr = "git worktree remove";
        gl = "git lg";
        gfu = "git fetch && git rebase origin/main";
        hey = "hei";
        k = "kubectl";
        kx = "kubectx";
        kns = "kubens";
        l = "ls";
        lg = "lazygit";
        sr = "sudo systemctl restart -v";
        vi = "nvim";
        wp = "woodpecker-cli";
        yolo = "git commit --amend -a && git push --force-with-lease";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      presets = [
        "pure-preset"
        "nerd-font"
      ];
    };
  };
}
