{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
let
  inherit (pkgs) stdenv;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  hasK3s =
    lib.hasAttr "profiles" osConfig
    && lib.hasAttr "k3s" osConfig.profiles
    && osConfig.profiles.k3s.enable;
in
{
  home.packages =
    with pkgs;
    [
      actionlint
      asciinema
      bat
      cargo
      cloudflared
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
      gist
      gnumake
      gnugrep
      go_1_22
      golangci-lint
      (google-cloud-sdk.withExtraComponents (
        with pkgs.google-cloud-sdk.components;
        [
          cloud-build-local
          gke-gcloud-auth-plugin
        ]
      ))
      gopls
      go-task
      gotestfmt
      grc
      inputs.dagger.packages.${system}.dagger
      inputs.devenv.packages.${system}.devenv
      inputs.hei.packages.${system}.default
      inputs.yaml2nix.packages.${system}.default
      jq
      kubectx
      lazygit
      luarocks
      lua-language-server
      nil
      nixfmt-rfc-style
      neofetch
      nixpkgs-review
      nix-output-monitor
      nix-your-shell
      nodePackages.typescript
      nodePackages.node2nix
      nodejs
      # ncdu
      nnn
      neovim
      ollama
      pre-commit
      promexplorer
      pssh
      ranger
      revup
      ripgrep
      sccache
      stylua
      tealdeer
      tfenv
      thefuck
      tflint
      unzip
      unixtools.watch
      uv
      wget
      yq-go
      btop

      # useful nix related tools
      cachix # adding/managing alternative binary caches hosted by cachix
    ]
    ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ]
    ++ lib.optionals stdenv.isLinux [
      nim2
      maim
      vscode
    ]
    ++ lib.optional (!hasK3s) kubectl
    ++ lib.optionals isNixOS [ wezterm ];
}
