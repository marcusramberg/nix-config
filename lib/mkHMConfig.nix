{ inputs }:
{
  system ? "x86_64-linux",
  extraModules ? [ ],
  user ? "marcus",
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {
    inherit user inputs;
    osConfig = {
      system = { };
      networking.hostName = "";
    };
  };
  modules = [
    {
      nixpkgs = {
        overlays = [ (import ../overlays inputs) ];
        config.allowUnfree = true;
      };
    }
    ../home
  ]
  ++ extraModules;
}
