_: {

  imports = [
    ./files.nix
    ./fish.nix
    ./linux.nix
    ./packages.nix
    ./python.nix
    ./programs.nix
    # ./tmux.nix
  ];

  home = { stateVersion = "23.05"; };
}
