name:
{ nixpkgs, inputs, system, user, overlays }:

let mkOptions = import ./mkOptions.nix;
in nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  inherit system;
  modules = [
    ../hosts/${name}
    ../nixos
    inputs.home-manager.nixosModules.home-manager
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
    })
  ];
}
