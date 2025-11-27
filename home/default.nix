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
    ./plasma
    ./programs.nix
    ./python.nix
    ./tmux.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.dank-shell.homeModules.dankMaterialShell.default
    inputs.dank-shell.homeModules.dankMaterialShell.niri
  ];

  home = {
    username = user;
    stateVersion = "23.05";
    homeDirectory = lib.mkDefault "/home/${user}";
  };
}
