system:
{ user, inputs, overlays, std, ... }:
let stable = inputs.stable.legacyPackages.${system};
in {
  nixpkgs = {
    # inherit overlays;
    inherit overlays;
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowUnsupportedSystem = true;
    };
  };

  home-manager = {
    # verbose = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = import ../home;
    extraSpecialArgs = {
      inherit inputs;
      inherit stable;
      inherit std;
    };
  };
}
