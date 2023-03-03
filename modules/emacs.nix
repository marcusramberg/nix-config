{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.editors.emacs;
  inherit (lib) types mkIf mkOption;
in {
  options.modules.editors.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    doom = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      forgeUrl = mkOption {
        type = types.str;
        default = "https://github.com";
      };
      repoUrl = mkOption {
        type = types.str;
        default = "${forgeUrl.default}/doomemacs/doomemacs";
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      # 28.2 + native-comp
      ((emacsPackagesFor emacsNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]))

      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf config.programs.gnupg.agent.enable
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      unstable.fava # HACK Momentarily broken on nixos-unstable
    ];

    lib.env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    fonts = [ pkgs.emacs-all-the-icons-fonts ];

    system.userActivationScripts = mkIf cfg.doom.enable {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
        fi
      '';
    };
  };
}
