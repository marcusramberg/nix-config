{ pkgs, inputs, ... }:
let inherit (pkgs) stdenv;
in {
  home.packages = with pkgs;
    [
      argocd
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
      inputs.hei.packages.${system}.default
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
}