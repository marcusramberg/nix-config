#!/usr/bin/env bash
nix develop --impure . --extra-experimental-features nix-command --extra-experimental-features flakes
