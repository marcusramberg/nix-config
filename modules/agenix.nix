{
  options,
  inputs,
  lib,
  pkgs,
  ...
}:

with builtins;
with lib;
let
  inherit (inputs) agenix;
  secretsDir = ../secrets;
  secretsFile = "${secretsDir}/secrets.nix";
in
{
  environment.systemPackages = [ agenix.packages.${pkgs.system}.agenix ];

  age = {
    secrets =
      if pathExists secretsFile then
        mapAttrs' (
          n: _:
          nameValuePair (removeSuffix ".age" n) {
            file = "${secretsDir}/${n}";
            owner = mkDefault "root";
          }
        ) (import secretsFile)
      else
        { };
    identityPaths =
      options.age.identityPaths.default
      ++ (filter pathExists [
        "/home/marcus/.ssh/id_ed25519"
        "/Users/marcus/.ssh/id_ed25519"
      ]);
  };
}
