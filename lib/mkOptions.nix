system: { user, inputs, overlays }:
{
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
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = import ../home;
    extraSpecialArgs = {
      stable = inputs.stable.legacyPackages.${system};
    };
  };
}
