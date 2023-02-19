name: { nixpkgs, inputs, home-manager, system, user, overlays }:
let
  mkOptions = import ./mkOptions.nix;
in
inputs.darwin.lib.darwinSystem rec {
  system = system;
  modules = [
    # Main `nix-darwin` config
    ../darwin
    # `home-manager` module
    home-manager.darwinModules.home-manager
    (mkOptions system { inherit user; inherit overlays; inherit inputs; })
  ];
}
