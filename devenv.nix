{ pkgs, ... }:
{

  cachix.pull = [
    "nix-community"
    "marcusramberg"
  ];
  languages.lua = {
    enable = true;
  };
  languages.nix = {
    enable = true;
  };
  packages = with pkgs; [
    lolcat
  ];
  # Structural diff
  difftastic.enable = true;

  pre-commit.hooks = {
    commitizen.enable = true;
    deadnix.enable = true;
    # luacheck.enable = true;
    markdownlint.enable = true;
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
    stylua.enable = true;
    yamllint.enable = true;
  };
  enterShell = ''
    head -n 7 README.md|tail -n4|lolcat
  '';
  enterTest = ''
    nix flake check
  '';
}
