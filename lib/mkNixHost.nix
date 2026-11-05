{ inputs }:
name:
{
  system ? "x86_64-linux",
  extraModules ? [ ],
  desktop ? false,
  # Desktop shell: "dux" or "fjordxy". Lives here rather than only as an
  # option because fjordxy's module (and niri-flake's, which replaces the
  # nixpkgs niri module) has to be imported, and imports can't depend on config.
  shell ? "dux",
}:
let
  inherit (inputs.nixpkgs) lib;
in
{
  imports = [
    ../nixos
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.home-manager
    (import ./options.nix { inherit inputs system; })
  ]
  ++ lib.optional desktop {
    profiles.desktop = {
      enable = true;
      inherit shell;
    };
  }
  ++ lib.optional (shell == "fjordxy") inputs.fjordxy.nixosModules.default
  ++ extraModules;

  clan.core.networking.targetHost = "root@${name}";
}
