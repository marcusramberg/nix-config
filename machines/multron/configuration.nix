{ lib, ... }:
{
  imports = [
  ./owner.nix
  ];
  networking.hostName=lib.mkForce "multron";
  aurora.desktop = "gnome";
  # lib/patchNixpkgs.nix applies nixpkgs PRs in an x86_64-linux derivation.
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  system.stateVersion = "26.05";
  aurora.imageLayout = lib.mkForce {
    rootUUID = "8e3c084b-44d8-5293-a753-ae3288c9274b";
    bootUUID = "41dc57cf-2d07-50f9-ba96-7c95cde85ada";
    efiUUID = "1FE0-7AA4";
  };
}
