name:
{ nixpkgs, inputs, system, user, overlays, extraModules ? null }:

let
  mkOptions = import ./mkOptions.nix;
  inherit (nixpkgs) lib;
in lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  inherit system;
  modules = lib.lists.flatten ([
    ../hosts/${name}
    ../nixos
    inputs.home-manager.nixosModules.home-manager
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
    })
  ] ++ lib.optional (extraModules != null) extraModules);
}
