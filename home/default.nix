{ inputs, ... }: {

  imports = [
    ./files.nix
    ./fish.nix
    ./linux.nix
    ./packages.nix
    ./python.nix
    ./programs.nix
    ./tmux.nix
    inputs.nix-index-database.hmModules.nix-index

  ];

  home = {
    username = "marcus";
    homeDirectory = "/home/marcus";
    stateVersion = "23.05";
  };
}
