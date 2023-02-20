{ config, pkgs, lib, stable, ... }:
{
  home.stateVersion = "22.05";
  home.file = import ./files.nix { inherit pkgs; };


  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index.enable = true;
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs.firefox.override
      {
        # See nixpkgs' firefox/wrapper.nix to check which options you can use
        cfg = {
          # Tridactyl native connector
          enableTridactylNative = true;
        };
      };
  };

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  #  programs.doom-emacs = {
  #    enable = true;
  #    doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
  #    # and packages.el files
  #  };
  programs.fish = import ./fish.nix { inherit pkgs; inherit lib; };
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  programs.keychain.enable = true;
  programs.navi.enable = true;
  programs.zoxide.enable = true;


  programs.tmux = import ./tmux.nix { inherit pkgs; };
  programs.neovim.extraConfig = ''
    :luafile ~/.config/nvim/init.lua 
  '';

  home.packages = with pkgs; [
    actionlint
    asciinema
    any-nix-shell
    bat
    cargo
    cocogitto
    coreutils
    curl
    exa
    deadnix
    delta
    git
    git-crypt
    git-extras
    git-lfs
    fd
    fortune
    gnumake
    go
    golangci-lint
    (google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.cloud-build-local pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    gopls
    go-task
    gotestfmt
    grc
    jq
    lazygit
    luarocks
    lua-language-server
    nodePackages.typescript
    nodePackages.node2nix
    nodejs-16_x
    neovim-nightly
    pre-commit
    pssh
    (import ./python.nix { inherit pkgs; })
    ranger
    ripgrep
    stylua
    tealdeer
    tfenv
    thefuck
    tflint
    unzip
    wget
    yq-go

    # useful nix related tools
    /* cachix # adding/managing alternative binary caches hosted by cachix */
    /* comma # run software from without installing it */
    /* niv # easy dependency management for nix projects */
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    stable.wezterm
    m-cli # useful macOS CLI commands
  ] ++ lib.optionals stdenv.isLinux [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
    copyq
    feh
    kubectl
    maim
    picom
    nitrogen
    volumeicon
    xcape
    xclip
    wezterm-nightly
  ];

}

