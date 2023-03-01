_: {

  languages.lua = { enable = true; };
  languages.nix = { enable = true; };
  # Structural diff
  difftastic.enable = true;

  pre-commit.hooks = {
    deadnix.enable = false;
    luacheck.enable = false;
    nixfmt.enable = true;
    statix.enable = true;
    stylua.enable = true;
    markdownlint.enable = true;
  };
  enterShell = ''
    echo "       __"
    echo ".-----|__.--.--.  .--------.-----.---.-.-----.-----.  .-----.-----."
    echo "|     |  |_   _|__|        |  -__|  _  |     |__ --|__|     |  _  |"
    echo "|__|__|__|__.__|__|__|__|__|_____|___._|__|__|_____|__|__|__|_____|"
  '';
}
