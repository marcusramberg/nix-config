name:
{ nixpkgs, inputs, system, user ? "marcus", overlays, std, extraModules ? null
}:
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
    inputs.nur.nixosModules.nur
    inputs.home-manager.nixosModules.home-manager
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
      inherit std;
    })
  ] ++ lib.optional (extraModules != null) extraModules);
}
