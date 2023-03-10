{ pkgs, lib, ... }: {
  enable = true;
  #useBabelfish = true;
  functions = {
    fish_greeting =
      "fortune art goedel wisdom tao literature songs-poems paradoxum; echo ''";
    rd = "fd $argv (git root)";
    run = "nix run nixpkgs#$argv[1] -- $argv[2..-1]";
  };
  shellAbbrs = {
    l = "ls";
    gc = "git commit";
    gs = "git status";
    gsu = "git status -uno";
    gp = "git pull";
    gb = "git branch";
    gd = "git diff";
    gwa = "git worktree add";
    gwl = "git worktree list";
    gwr = "git worktree remove";
    gl = "git log";
    vi = "nvim";
    gfu = "git fetch --all --prune && git rebase origin/main";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    k = "kubectl";
    kx = "kubectx";
    kns = "kubens";
  };
  shellAliases = {
    cat = "bat";
    ls = "exa";
    ag = "rg";
    emacs = "emacs -nw";
    r = "cd (git root)";
    imgcat = "wezterm imgcat";
    gcp =
      "gcloud config set project (gcloud projects list --format='get(project_id)' --sort-by=project_id --filter='project_id != ^sys-'|fzf)";
    # } ++
    # lib.optionals pkgs.stdenv.isLinux {
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";
  };

  shellInit = ''
    fish_add_path /.dotfiles/bin /usr/local/sbin ${
      lib.optionalString pkgs.stdenv.isLinux "/etc/nixos/bin"
    }
    fish_add_path -a /run/current_system/sw/bin ~/.local/bin /opt/homebrew/bin ~/go/bin/ ~/.nimble/bin ~/.cargo/bin/
    set CLOUDSDK_PYTHON_SITEPACKAGES 1
  '';
  interactiveShellInit = ''
    fish_vi_key_bindings
    set fish_theme nord
    set -gx EDITOR nvim
    source ~/.config/fish/tide_config.fish
    type -q thefuck; and thefuck --alias | source
    test -x ~/.plenv/bin/plenv; and . (~/.plenv/bin/plenv init -|psub)
    if [ -f '/Users/marcus/google-cloud-sdk/path.fish.inc' ]; . '/Users/marcus/google-cloud-sdk/path.fish.inc'; end

    # Completion
    type -q kustomize; and eval (kustomize completion fish)
    type -q yq; and yq shell-completion fish | source

    type -q nvm; and nvm use -s
    source ~/.config/fish/tide_config.fish
    any-nix-shell fish --info-right | source
  '';
  loginShellInit = ''
    if [ -f /Users/marcus/.ssh/id_rsa ]
      ssh-add -q --apple-use-keychain  ~/.ssh/id_rsa
      ssh-add -q --apple-use-keychain  ~/.ssh/id_dsa
      ssh-add -q --apple-use-keychain  ~/.ssh/google_compute_engine
    end
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent
  '';
  plugins = [
    {
      name = "tide";
      inherit (pkgs.fishPlugins.tide) src;
    }
    {
      name = "grc";
      inherit (pkgs.fishPlugins.grc) src;
    }
    {
      name = "forgit";
      inherit (pkgs.fishPlugins.forgit) src;
    }
    {
      name = "bass";
      inherit (pkgs.fishPlugins.bass) src;
    }
    {
      name = "fzf-fish";
      inherit (pkgs.fishPlugins.fzf-fish) src;
    }
    {
      name = "gcloud-completions";
      src = pkgs.fetchFromGitHub {
        owner = "lgathy";
        repo = "google-cloud-sdk-fish-completion";
        rev = "bc24b0bf7da2addca377d89feece4487ca0b1e9c";
        sha256 = "BIbzdxAj3mrf340l4hNkXwA13rIIFnC6BxM6YuJ7/w8=";
      };
    }
  ];
}
