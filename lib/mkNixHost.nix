{ inputs }:
name:
{
  system ? "x86_64-linux",
  extraModules ? [ ],
  desktop ? false,
}:
{
  imports = [
    ../nixos
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    (import ./options.nix { inherit inputs system; })
  ]
  ++ (if desktop then [ { profiles.desktop.enable = true; } ] else [ ])
  ++ extraModules;

  clan.core.networking.targetHost = "root@${name}";
}
