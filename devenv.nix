{ ... }: {
  languages.lua = {
    enable = true;
  };
  languages.nix = {
    enable = true;
  };
  pre-commit.hooks = {
    nixpkgs-fmt.enable = true;
    # deadnix.enable = true;
  };
}
