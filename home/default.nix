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
    ./niri
    ./packages.nix
    ./programs.nix
    ./python.nix
    ./tmux.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home = {
    username = user;
    stateVersion = "23.05";
    homeDirectory = lib.mkDefault "/home/${user}";
    enableNixpkgsReleaseCheck = false;
  };
}
