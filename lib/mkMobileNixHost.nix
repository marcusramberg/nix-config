name:
{ nixpkgs, inputs, system, user, overlays }:

let mkOptions = import ./mkOptions.nix;
in nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  inherit system;

  modules = [
    ../hosts/${name}
    inputs.home-manager.nixosModules.home-manager
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
    })
    (import "${inputs.mobile-nixos}/lib/configuration.nix" {
      device = "oneplus-fajita";
    })
  ];
}
