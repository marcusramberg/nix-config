name:
{ nixpkgs, inputs, system, user ? "marcus", overlays, std, extraModules ? null
}:
let
  mkOptions = import ./mkOptions.nix;
  inherit (nixpkgs) lib;
in inputs.home-manager.lib.homeManagerConfiguration {
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  inherit system;
  modules = lib.lists.flatten ([
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
      inherit std;
    })
  ] ++ lib.optional (extraModules != null) extraModules);
}
