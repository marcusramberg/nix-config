# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ ./alt
#                       └─ native.nix *
#

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.doom;
in
{
  options.profiles.doom.enable = lib.mkEnableOption "doom";

  config = lib.mkIf cfg.enable {
    services.emacs.enable = false;

    system.userActivationScripts = {
      # Installation script every time nixos-rebuild is run. So not during initial install.
      doomEmacs = {
        text = ''
          source ${config.system.build.setEnvironment}
          EMACS="$HOME/.emacs.d"

          if [ ! -d "$EMACS" ]; then
            ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git $EMACS
            yes | $EMACS/bin/doom install
            $EMACS/bin/doom sync
          else
            $EMACS/bin/doom sync
          fi
        ''; # It will always sync when rebuild is done. So changes will always be applied.
      };
    };

    environment.systemPackages = with pkgs; [
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      ripgrep
      coreutils
      fd
      #git
    ]; # Dependencies
  };
}
