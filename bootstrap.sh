#!/usr/bin/env bash
export NIX_CONFIG="substituters = https://cache.nixos.org https://gradient.bas.es/cache/marcus\ntrusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= gradient.bas.es-marcus:vD9XjZdexiZrVjK09hidipfPrAKF75fKL8i5p/qdrkw="
nix develop --impure . --extra-experimental-features nix-command --extra-experimental-features flakes
