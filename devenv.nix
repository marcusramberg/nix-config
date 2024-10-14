_: {

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
    echo "       __"
    echo ".-----|__.--.--.  .--------.-----.---.-.-----.-----.  .-----.-----."
    echo "|     |  |_   _|__|        |  -__|  _  |     |__ --|__|     |  _  |"
    echo "|__|__|__|__.__|__|__|__|__|_____|___._|__|__|_____|__|__|__|_____|"
  '';
  enterTest = ''
    nix flake check
  '';
}
