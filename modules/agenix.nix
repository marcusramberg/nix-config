# modules/agenix.nix -- encrypt secrets in nix store

{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
let
  inherit (inputs) agenix;
  secretsDir = ../secrets;
  secretsFile = "${secretsDir}/secrets.nix";
in
{
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets =
      if pathExists secretsFile
      then
        mapAttrs'
          (n: _: nameValuePair (removeSuffix ".age" n) {
            file = "${secretsDir}/${n}";
            owner = mkDefault config.user.name;
          })
          (import secretsFile)
      else { };
    identityPaths =
      options.age.identityPaths.default ++ (filter pathExists [
        "/home/marcus/.ssh/id_ed25519"
        "/home/marcus/.ssh/id_rsa"
      ]);
  };
}
