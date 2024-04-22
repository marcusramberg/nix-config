{ inputs, lib, user, ... }: {

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
    username = user;
    stateVersion = "23.05";
    homeDirectory = lib.mkDefault "/home/${user}";
  };
}
