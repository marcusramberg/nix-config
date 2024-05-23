{ pkgs, lib, osConfig, inputs, ... }:
let
  inherit (pkgs) stdenv;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
in {
  home.packages = with pkgs;
    [
      argocd
      actionlint
      asciinema
      any-nix-shell
      bat
      cargo
      cloudflared
      cocogitto
      coreutils
      nodePackages.cspell
      curlHTTP3
      deadnix
      delta
      dive
      # docker
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
      gist
      glow
      go_1_22
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
      inputs.dagger.packages.${system}.dagger
      inputs.devenv.packages.${system}.devenv
      inputs.hei.packages.${system}.default
      inputs.yaml2nix.packages.${system}.default
      jq
      kubectl
      kubectx
      lazygit
      luarocks
      lua-language-server
      nil
      mosh
      nixfmt-rfc-style
      neofetch
      nixpkgs-review
      nom
      nodePackages.typescript
      nodePackages.node2nix
      nodejs
      ncdu
      nnn
      neovim
      ollama
      pre-commit
      promexplorer
      pssh
      ranger
      revup
      ripgrep
      stylua
      tealdeer
      tfenv
      thefuck
      tflint
      unzip
      vscode
      wget
      yq-go
      btop
      kubectl

      # useful nix related tools
      # cachix # adding/managing alternative binary caches hosted by cachix
      # niv # easy dependency management for nix projects
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ] ++ lib.optionals stdenv.isLinux [ nim2 maim ]
    ++ lib.optionals isNixOS [ wezterm ];
}
