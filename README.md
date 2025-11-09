# marcsuramberg's nix flake

```ascii
       __
,—————|__|——.——、 ,————————.—————.———.—.—————.—————、 ,—————.—————、
|     |  |_   _|__|        |  —__|  _  |     |__ ——|__|     |  _  |
|__|__|__|__.__|__|__|__|__|_____|___._|__|__|_____|__|__|__|_____|
```

## Supports

- My media center / home hub
- Thinkpad
- Mac x86 laptop running nixos
- M1 Studio running NixOS/nix-darwin dual boot on my desktop
- NixOS based router
- Steam deck + Gaming desktop using [Jovian](https://jovian-experiments.github.io/Jovian-NixOS/)
- Various experiments
- +++

This configuration is based on using flakes, nix-darwin and home manager.

I mostly interact with it on NixOS using
[hei](https://github.com/marcusramberg/hei), my rewrite of
[hlissner](https://github.com/hlissner/dotfiles)'s hey script. His
config is also the inspiration for using Agenix for secrets management.
Other honorable mentions go to [Mitchell Hashimoto's
nixos-config](https://github.com/mitchellh/nixos-config) and
[k900](https://gitlab.com/k900/nix) from which I've also stolen a lot :)

Obviously this is always a WIP.

## Folder structure

- `config`/ - Configuration files to be installed in home
- `darwin`/ - Nix-darwin specific configuration
- `nixos`/ - NixOS specific configuration
- `secrets`/ - Secrets to be decrypted with agenix
- `home`/ - Shared Home manager configuration
- `modules`/ - Shared Nix modules
- `lib`/ - Shared Nix library functions
- `machines`/ - Machine specific configuration
- `overlays`/ - Nix custom package overlay
- `packages`/ - Nix custom packages
- `wallpaper/` - Wallpaper for my desktop
