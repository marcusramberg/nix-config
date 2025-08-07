{
  description = "nix.means.no";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "darwin";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };
    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
    };
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      # Don't do this if your machines are on nixpkgs stable.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:nix-community/flake-compat";
    hei = {
      url = "github:marcusramberg/hei";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-std.url = "github:chessai/nix-std";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    systems.url = "github:nix-systems/default";
    tfenv.flake = false;
    tfenv.url = "github:tfutils/tfenv";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    unattended-installer = {
      url = "github:chrillefkr/nixos-unattended-installer";
      inputs = {
        disko.follows = "disko";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      flake-parts,
      hei,
      ...

    }@inputs:
    with import ./lib { inherit inputs; };
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.clan-core.flakeModules.default
      ];
      clan = {
        # Clan wide settings. (Required)
        meta.name = "means_no";
        machines = {
          mstudio = mkNixHost "mstudio" {
            extraModules = [
              inputs.apple-silicon-support.nixosModules.apple-silicon-support
            ];
            system = "aarch64-linux";
          };
          mhub = mkNixHost "mhub" { };
          mhome = mkNixHost "mhome" {
            extraModules = [ inputs.disko.nixosModules.disko ];
          };
          butterbee = mkNixHost "butterbee" { system = "aarch64-linux"; };
          mbook = mkNixHost "mbook" {
            system = "aarch64-linux";
            extraModules = [
              inputs.apple-silicon-support.nixosModules.apple-silicon-support
            ];
          };
          mbox = mkNixHost "mbox" {
            extraModules = [ inputs.jovian.nixosModules.default ];
          };
          mtop = mkNixHost "mtop" { };
          mbench = mkNixHost "mbench" {
            extraModules = [ inputs.disko.nixosModules.disko ];
          };
          mdeck = mkNixHost "mdeck" {
            extraModules = [ inputs.jovian.nixosModules.default ];
          };
          mgate = mkNixHost "mgate" { };
          mlab = mkNixHost "mlab" { };
          mrack01 = mkNixHost "mrack01" {
            extraModules = [ inputs.disko.nixosModules.default ];
          };
          mvirt = mkNixHost "mvirt" { };
        };
        specialArgs = { inherit inputs self; };
      };
      flake = {
        installers = builtins.mapAttrs (
          _: config:
          (inputs.unattended-installer.lib.diskoInstallerWrapper config { }).config.system.build.isoImage
        ) self.nixosConfigurations;

        darwinConfigurations.mwork = mkDarwinHost "mwork" { };
        darwinConfigurations.mStudio = mkDarwinHost "mstudio" { };
        homeConfigurations = {
          marcus = mkHMConfig { };
          aarch64 = mkHMConfig { system = "aarch64-linux"; };
          mac = mkHMConfig { system = "aarch64-darwin"; };
        };
      };
      perSystem =
        { pkgs, system, ... }:
        {
          apps.default = {
            type = "app";
            program = "${hei.packages.${system}.default}/bin/hei";
          };
          devShells.default = pkgs.mkShellNoCC {
            NIX_CONFIG = "experimental-features = nix-command flakes";
            packages = with pkgs; [
              git
              go-task
              inputs.clan-core.packages.${system}.clan-cli
              lolcat
              home-manager
              neovim
            ];
            shellHook = ''
              head -n 7 README.md|tail -n4|lolcat
            '';
          };
          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixfmt-rfc-style.enable = true;
                deadnix.enable = true;
                statix.enable = true;
              };
            };
          };
        };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    });
}
