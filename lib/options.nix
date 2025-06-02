{
  system,
  inputs,
  ...
}:
{
  nixpkgs = {
    overlays = [ (import ../overlays inputs) ];
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
    hostPlatform = system;
  };

  home-manager = {
    # verbose = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    useUserPackages = true;
    users.marcus = import ../home;
    extraSpecialArgs = {
      user = "marcus";
      inherit inputs;
    };
  };
}
