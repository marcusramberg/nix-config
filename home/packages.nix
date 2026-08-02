{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
let
  inherit (pkgs) stdenv;
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
      btop
      caligula
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
      gnugrep
      gnumake
      go
      go-task
      golangci-lint
      gopls
      gotestfmt
      grc
      hadolint
      inputs.hei.packages.${stdenv.hostPlatform.system}.default
      jq
      just
      lolcat
      lsof
      lua-language-server
      luarocks
      lua5_1
      lynx # for copilot
      ncdu
      nil
      inputs.theheck.packages.${stdenv.hostPlatform.system}.default
      nix-output-monitor
      nixfmt
      nixpkgs-review
      nix-converter
      nodejs
      nono
      otree
      prek
      promexplorer
      ripgrep
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
    ++ lib.optional (!hasK3s) kubectl;
}
