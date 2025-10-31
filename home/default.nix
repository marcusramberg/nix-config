{
  inputs,
  lib,
  user,
  ...
}:
{

  imports = [
    ./files.nix
    ./fish.nix
    ./git.nix
    ./linux.nix
    ./packages.nix
    ./python.nix
    ./plasma.nix
    ./programs.nix
    ./tmux.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  home = {
    username = user;
    stateVersion = "23.05";
    homeDirectory = lib.mkDefault "/home/${user}";
  };
}
