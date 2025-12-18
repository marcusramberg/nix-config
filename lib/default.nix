{
  inputs,
}:
let
  # Centralized overlays configuration
  commonOverlays = [
    (import ../overlays inputs)
    inputs.ghostty.overlays.default
    inputs.quickshell.overlays.default
  ];

  # Common nixpkgs configuration
  commonNixpkgsConfig = {
    allowUnfree = true;
    allowBroken = true;
  };

  # Common home-manager configuration
  commonHomeManagerConfig = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    useUserPackages = true;
    users.marcus = import ../home;
    extraSpecialArgs = {
      user = "marcus";
      inherit inputs;
    };
  };

  # Common system configuration module for both NixOS and Darwin
  mkSystemConfigModule = system: {
    nixpkgs = {
      overlays = commonOverlays;
      config = commonNixpkgsConfig;
      hostPlatform = system;
    };
    home-manager = commonHomeManagerConfig;
  };
  mkDarwinHost =
    name:
    {
      system ? "aarch64-darwin",
      user ? "marcus",
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit user inputs;
      };
      modules = [
        # Main `nix-darwin` config
        ../machines/${name}
        ../darwin
        # `home-manager` module
        inputs.home-manager.darwinModules.home-manager
        (mkSystemConfigModule system)
      ];
    };

  mkDesktopHost =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    let
      modules = [
        {
          profiles.desktop.enable = true;
        }
      ]
      ++ extraModules;
    in
    mkNixHost name {
      inherit system;
      extraModules = modules;
    };
  mkNixHost =
    name:
    {
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    {
      imports = [
        ../nixos
        inputs.agenix.nixosModules.age
        inputs.home-manager.nixosModules.home-manager
        (mkSystemConfigModule system)
      ]
      ++ extraModules;
      clan.core.networking.targetHost = "root@${name}";
      nixpkgs.hostPlatform = system;
    };
  mkHMConfig =
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
          networking = {
            hostName = "";
          };
        };
      };
      modules = [
        {
          nixpkgs = {
            overlays = commonOverlays;
            config = commonNixpkgsConfig;
          };
        }
        ../home/default.nix
      ]
      ++ extraModules;
    };
in
{
  inherit
    mkDarwinHost
    mkNixHost
    mkDesktopHost
    mkHMConfig
    ;
}
