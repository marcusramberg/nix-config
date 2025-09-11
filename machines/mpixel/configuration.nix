# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ lib, pkgs, ... }:
{
  # Change default user
  avf.defaultUser = "marcus";
  environment.systemPackages = with pkgs; [
    git
    openssh
    neovim
  ];

  system.stateVersion = lib.mkForce "25.11";
}
