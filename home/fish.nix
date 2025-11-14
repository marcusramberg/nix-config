{
  pkgs,
  lib,
  user,
  osConfig,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = pkgs.stdenv.isLinux && (isNixOS && osConfig.services.desktopManager.plasma6.enable);
in
{
  programs.bash = {
    enable = true;
    # initExtra = ''
    #   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #   then
    #     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #   fi
    # '';
  };
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = " hostname | , figlet -f rozzo   |lolcat -t -F 0.4";
      rd = "fd $argv (git root)";
      nuke = ''
        if test (count $argv) -lt 1
          echo 'nuke: missing target argument' >&2
          return 1
         end
        git reset $argv && git checkout $argv
      '';
      run = ",";
      fish_title = ''echo (hostname -s)": "(prompt_pwd)'';
    };
    shellAbbrs = {
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
    shellAliases = {
      ag = "rg";
      cat = "bat";
      emacs = "emacs -nw";
      gcp = "gcloud config set project (gcloud projects list --format='get(project_id)' --sort-by=project_id --filter='project_id != ^sys-'|fzf)";
      git-hash = "git log -1 --format=%H| tee /dev/tty |pbcopy";
      hackerpass = "env PASSWORD_STORE_GPG_OPTS=\"--trust-model always\" PASSWORD_STORE_DIR=/home/marcus/.hackeriet_pass , pass";
      imgcat = "wezterm imgcat";
      pbcopy = if pkgs.stdenv.isLinux then "wl-copy" else "pbcopy";
      pbpaste = if pkgs.stdenv.isLinux then "wl-paste" else "pbpaste";
      r = "cd (git root)";
    };

    shellInit = ''
      fish_add_path -p ~/.local/bin ${lib.optionalString isDarwin "/run/current-system/sw/bin /opt/homebrew/bin"} ~/go/bin/ ~/.nimble/bin ~/.cargo/bin/
    '';
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default     block      blink
      set fish_cursor_insert      line       blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual      block
      set fish_theme tokyonight
      set -gx EDITOR nvim
      set -gx GOPRIVATE github.com/reMarkable
      # FIXME: Disable this for now as it breaks vi mode.
      set --universal pure_enable_nixdevshell false
      test -x ~/.plenv/bin/plenv; and . (~/.plenv/bin/plenv init -|psub)
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      set -gx ATUIN_NOBIND "true"
      atuin init fish | source

      # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search

      # Completion
      type -q kustomize; and eval (kustomize completion fish)
      type -q yq; and yq shell-completion fish | source
    ''
    + lib.optionalString isNixOS ''
      set -gx NIX_LD (nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD ')
      if test "$TERM" = "xterm-ghostty"
        . ${pkgs.ghostty.shell_integration}/fish/vendor_conf.d/ghostty-shell-integration.fish
      end
    ''
    + lib.optionalString isDesktop ''
      set SSH_ASKPASS "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass"
    '';
    loginShellInit = ''
      gpgconf --launch gpg-agent
      if [ -f /Users/${user}/.ssh/id_rsa ]
        ssh-add -q --apple-use-keychain  ~/.ssh/id_rsa
        ssh-add -q --apple-use-keychain  ~/.ssh/google_compute_engine
      end
      set -x GPG_TTY (tty)
    ''
    + lib.optionalString isDarwin ''
      set -x SSH_AUTH_SOCK /Users/marcus/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
    '';
    plugins = [
      # {
      #   name = "fzf-fish";
      #   inherit (pkgs.fishPlugins.fzf-fish) src;
      # }
      {
        name = "pure";
        inherit (pkgs.fishPlugins.pure) src;
      }
      {
        name = "bass";
        inherit (pkgs.fishPlugins.bass) src;
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
  };
}
