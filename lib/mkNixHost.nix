name: { nixpkgs, inputs, home-manager, system, user, overlays }:

nixpkgs.lib.nixosSystem
rec {
  specialArgs = { inherit inputs; };
  inherit system;
  modules = [
    ../hosts/${name}
    ../nixos
    inputs.nixos-wsl.nixosModules.wsl
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs = {
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
  ];
}
