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
      (fortune.override { withOffensive = true; })
      actionlint
      asciinema
      btop
      caddy
      caligula
      cargo
      chafa
      cloudflared
      coreutils
      deadnix
      devenv
      dive
      fastfetch
      fd
      figlet
      gist
      github-copilot-cli
      glow
      gnugrep
      gnumake
      go
      go-task
      golangci-lint
      gopls
      gotestfmt
      grc
      inputs.hei.packages.${stdenv.hostPlatform.system}.default
      jq
      just
      kubectx
      lolcat
      lua-language-server
      luarocks
      lua5_1
      lynx # for copilot
      man-pages
      ncdu
      neovim
      nil
      nim2
      inputs.mcp-hub.packages.${stdenv.hostPlatform.system}.default
      nix-converter
      nix-output-monitor
      nixfmt-rfc-style
      nixpkgs-review
      nnn
      nodePackages.cspell
      nodePackages.typescript
      nodejs
      ollama
      otree
      prek
      promexplorer
      pssh
      ranger
      ripgrep
      sccache
      sqlite
      statix
      stylua
      tealdeer
      tfenv
      tflint
      unixtools.watch
      unzip
      uv
      wget
      woodpecker-cli
      yq-go
    ]
    ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ]
    ++ lib.optional (!hasK3s) kubectl
    ++ lib.optionals isNixOS [ wezterm ];
}
