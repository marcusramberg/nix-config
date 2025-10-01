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
      any-nix-shell
      btop
      caddy
      caligula
      cargo
      cloudflared
      coreutils
      curlHTTP3
      deadnix
      devenv
      dive
      fastfetch
      fd
      gist
      gnugrep
      gnumake
      go
      go-task
      golangci-lint
      gopls
      gotestfmt
      grc
      inputs.hei.packages.${system}.default
      jq
      just
      kubectx
      lua-language-server
      luarocks
      lynx # for copilot
      ncdu
      neovim
      nil
      nim2
      inputs.mcp-hub.packages.${system}.default
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
      promexplorer
      pssh
      ranger
      ripgrep
      sccache
      sqlite
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
