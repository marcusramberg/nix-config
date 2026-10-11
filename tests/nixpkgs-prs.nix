# Evaluated by checks.<system>.nixpkgs-prs in pure flake evaluation.
{ inputs, system }:
let
  original = inputs.nixpkgs;
  pkgs = original.legacyPackages.${system};
  # Substitute local patch fixtures for the downloads while exercising the
  # real patch build, flake exports, package import, and module evaluation.
  fixtureInput = original // {
    legacyPackages.${system} = pkgs // {
      applyPatches =
        args:
        assert builtins.length args.patches == 2;
        pkgs.applyPatches (
          args
          // {
            patches = [
              ./module.patch
              ./package.patch
            ];
          }
        );
    };
  };
  patched =
    (import ../lib {
      inputs = inputs // {
        nixpkgs = fixtureInput;
      };
      nixpkgsPatchSystem = system;
      nixpkgsPRs = [
        {
          number = 1;
          hash = pkgs.lib.fakeHash;
        }
        {
          number = 2;
          hash = pkgs.lib.fakeHash;
        }
      ];
    }).inputs.nixpkgs;
  host = patched.lib.nixosSystem {
    modules = [
      {
        nixpkgs.hostPlatform = system;
        system.stateVersion = "26.05";
      }
    ];
  };
in
assert (import ../lib { inherit inputs; }).inputs.nixpkgs.outPath == original.outPath;
assert patched.outPath != original.outPath;
assert host.config.nixpkgsPRTest == "module-patched";
assert host.pkgs.nixpkgsPRTest == "package-patched";
assert host.config.nixpkgs.flake.source == patched.outPath;
assert patched.legacyPackages.${system}.nixpkgsPRTest == "package-patched";
{
  emptyList = true;
  moduleChanges = true;
  packageChanges = true;
  moduleSource = true;
}
