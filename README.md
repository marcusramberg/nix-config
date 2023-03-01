# nix.means.no

## Supports

* my media center / home hub
* VM running in Parallels,
* Mac laptop
* Nix running in WSL 2 on my Gaming PC

This configuration is heavily based around using flakes and home manager

I mostly interact with it on nixos using `hey`, stolen from
[hlissner](https://github.com/hlissner/dotfiles). This
config is also the inspiration for using agenix for secrets management.
Other honorable mentions go to [Mitchell
Hashimoto's nixos-config](https://github.com/mitchellh/nixos-config).
from which I've also stolen a lot :)]

Obviously this is always a WIP.

## Folder structure

* config/ - Configuration files to be installed in home
* darwin/ - Nix-darwin specific configuration
* nixos/ - NixOS specific configuration
* secrets/ - Secrets to be decrypted with agenix
* home/ - Shared Home manager configuration
* modules/ - Shared Nix modules
* lib/ - Shared Nix library functions
* hosts/ - Host specific configuration
* overlays/ - Nix custom package overlay
* packages/ - Nix custom packages
* wallpaper/ - Wallpaper for my desktop
