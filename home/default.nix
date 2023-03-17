{ pkgs, lib, inputs, ... }: {

  home.stateVersion = "22.05";
  home.file = import ./files.nix { inherit pkgs; };

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
    package = pkgs.firefox.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      cfg = {
        # Tridactyl native connector
        enableTridactylNative = true;
      };
    };
  };
  programs.chromium.enable = pkgs.stdenv.isLinux;
  programs.starship = import ./starship.nix { };

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir =
  #     ../config/doom.d; # Directory containing your config.el, init.el
  #   # and packages.el files
  # };

  programs.fish = import ./fish.nix {
    inherit pkgs;
    inherit lib;
  };
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

  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  home.packages = with pkgs;
    [
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
      git-recent
      fd
      fortune
      gnumake
      go
      golangci-lint
      (google-cloud-sdk.withExtraComponents
        (with pkgs.google-cloud-sdk.components; [
          cloud-build-local
          gke-gcloud-auth-plugin
        ]))
      gopls
      go-task
      gotestfmt
      grc
      inputs.devenv.packages.${system}.devenv
      jq
      lazygit
      luarocks
      lua-language-server
      nodePackages.typescript
      nodePackages.node2nix
      nodejs-16_x
      ncdu
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
      # cachix # adding/managing alternative binary caches hosted by cachix
      # comma # run software from without installing it
      # niv # easy dependency management for nix projects
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      wezterm
      m-cli # useful macOS CLI commands
    ] ++ lib.optionals stdenv.isLinux [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
      btop
      copyq
      feh
      kubectl
      maim
      picom
      nitrogen
      rofi
      vivaldi
      volumeicon
      xcape
      xclip
      wezterm-nightly
    ];

}

