{
  inputs,
  nixpkgsPRs ? [ ],
  nixpkgsPatchSystem ? "x86_64-linux",
}:
let
  patchedInputs = inputs // {
    nixpkgs = import ./patchNixpkgs.nix {
      inherit (inputs) nixpkgs;
      prs = nixpkgsPRs;
      system = nixpkgsPatchSystem;
    };
  };
  mkNixHost = import ./mkNixHost.nix { inputs = patchedInputs; };
in
{
  inputs = patchedInputs;
  inherit mkNixHost;
  mkDesktopHost = name: options: mkNixHost name (options // { desktop = true; });
  mkHMConfig = import ./mkHMConfig.nix { inputs = patchedInputs; };
}
