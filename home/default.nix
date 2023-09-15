{ pkgs, lib, inputs, ... }: {

  home = {
    stateVersion = "22.05";
    file = import ./files.nix { inherit pkgs; };
    packages = with pkgs;
      [
        awscli2
        actionlint
        asciinema
        any-nix-shell
        bat
        cargo
        cocogitto
        coreutils
        curl
        deadnix
        delta
        git
        git-crypt
        git-extras
        git-lfs
        git-recent
        gitAndTools.gh
        fd
        fortune
        gnumake
        gnugrep
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
        inputs.hei.packages.${system}.hei
        jq
        kubectl
        kubectx
        lazygit
        luarocks
        lua-language-server
        nil
        mosh
        neofetch
        nodePackages.typescript
        nodePackages.node2nix
        nodejs
        ncdu
        nnn
        neovim
        pre-commit
        promexplorer
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
        wezterm

        # useful nix related tools
        # cachix # adding/managing alternative binary caches hosted by cachix
        # comma # run software from without installing it
        # niv # easy dependency management for nix projects
      ] ++ lib.optionals stdenv.isDarwin [
        cocoapods
        m-cli # useful macOS CLI commands
      ] ++ lib.optionals stdenv.isLinux [ btop kubectl maim nim nimlsp ];
  };
  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
      git = true;
    };
    chromium.enable = pkgs.stdenv.isLinux;
    difftastic = {
      background = "dark";
      display = "inline";
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = import ./fish.nix {
      inherit pkgs;
      inherit lib;
    };
    firefox = {
      enable = pkgs.stdenv.isLinux;
      package = pkgs.firefox.override {
        # See nixpkgs' firefox/wrapper.nix to check which options you can use
        cfg = {
          # Tridactyl native connector
          enableTridactylNative = true;
        };
      };
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
    # starship = import ./starship.nix { };
    tmux = import ./tmux.nix { inherit pkgs; };
    # Smarter z
    zoxide.enable = true;
  };

  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

}

