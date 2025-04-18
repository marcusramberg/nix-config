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
      cloudflared
      coreutils
      nodePackages.cspell
      caligula
      cargo
      curlHTTP3
      deadnix
      devenv
      dive
      fd
      (fortune.override { withOffensive = true; })
      gist
      gnumake
      gnugrep
      go
      golangci-lint
      gopls
      go-task
      gotestfmt
      grc
      inputs.hei.packages.${system}.default
      inputs.nix-converter.packages.${system}.default
      jq
      just
      kubectx
      luarocks
      lua-language-server
      nil
      lynx # for copilot
      nixfmt-rfc-style
      fastfetch
      nixpkgs-review
      nix-output-monitor
      nix-your-shell
      nodePackages.typescript
      nodejs
      ncdu
      nim2
      nnn
      neovim
      ollama
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
      unzip
      unixtools.watch
      uv
      wget
      yq-go
      btop
    ]
    ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ]
    # ++ lib.optionals stdenv.isLinux [
    #   # bitwarden-cli
    #   maim
    # ]
    ++ lib.optional (!hasK3s) kubectl
    ++ lib.optionals isNixOS [ wezterm ];
}
