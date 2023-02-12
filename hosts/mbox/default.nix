{ pkgs, config, modulesPath, ... }:

let
  nixos-wsl = import ./nixos-wsl;
in
{
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "marcus";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  system.stateVersion = "22.11";
}
