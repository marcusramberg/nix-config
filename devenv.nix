{ ... }: {
  languages.lua = { enable = true; };
  languages.nix = { enable = true; };
  # Structural diff
  difftastic.enable = true;

  pre-commit.hooks = {
    luacheck.enable = false;
    stylua.enable = true;
    nixfmt.enable = true;
    deadnix.enable = false;
  };
}
