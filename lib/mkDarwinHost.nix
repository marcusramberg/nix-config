{ inputs, system, user ? "marcus", overlays, std }:
let mkOptions = import ./mkOptions.nix;
in inputs.darwin.lib.darwinSystem rec {
  inherit system;
  specialArgs = {
    inherit inputs;
    inherit user;
  };
  modules = [
    # Main `nix-darwin` config
    ../darwin
    # `home-manager` module
    inputs.home-manager.darwinModules.home-manager
    (mkOptions system {
      inherit user;
      inherit overlays;
      inherit inputs;
      inherit std;
    })
  ];
}
