{
  config,
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
let
  inherit (pkgs) stdenv;
  cfg = config.profiles.home;
  hasK3s = lib.attrByPath [ "profiles" "k3s" "enable" ] false osConfig;
  # Standalone home-manager (no NixOS profiles) keeps dev tools; NixOS hosts
  # follow their desktop profile unless overridden.
  desktopDefault =
    if osConfig ? profiles then lib.attrByPath [ "desktop" "enable" ] false osConfig.profiles else true;

  base = with pkgs; [
    (fortune.override { withOffensive = true; })
    btop
    caligula
    chafa
    cloudflared
    coreutils
    fastfetch
    fd
    figlet
    gnugrep
    grc
    inputs.hei.packages.${stdenv.hostPlatform.system}.default
    jq
    lolcat
    lsof
    ncdu
    inputs.theheck.packages.${stdenv.hostPlatform.system}.default
    nono
    otree
    ripgrep
    sqlite
    tealdeer
    unixtools.watch
    unzip
    wget
    yq-go
  ];

  dev =
    with pkgs;
    [
      actionlint
      deadnix
      devenv
      dive
      gist
      github-copilot-cli
      gnumake
      go
      go-task
      golangci-lint
      gopls
      gotestfmt
      hadolint
      just
      lua-language-server
      luarocks
      lua5_1
      lynx # for copilot
      nil
      nix-output-monitor
      nixfmt
      nixpkgs-review
      nix-converter
      nodejs
      prek
      promexplorer
      statix
      stylua
      tfenv
      tflint
      uv
      woodpecker-cli
    ]
    ++ lib.optional (!hasK3s) kubectl;
in
{
  options.profiles.home.dev.enable = lib.mkOption {
    type = lib.types.bool;
    default = desktopDefault;
    description = "Developer CLI tooling (compilers, LSPs, linters, CI) in home-manager";
  };

  config.home.packages = base ++ lib.optionals cfg.dev.enable dev;
}
