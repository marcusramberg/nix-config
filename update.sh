#!/usr/bin/env bash
attic login local https://cache.bas.es/ $ATTIC_TOKEN
attic use bases
nix-fast-build --attic bases -f .#devShells.x86_64-linux.default --no-nom --skip-cached --no-link
nix-fast-build --attic bases -f .#nixosConfigurations.mdeck.config.system.build.toplevel --no-nom --skip-cached --no-link
