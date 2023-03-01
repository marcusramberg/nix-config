let
  marcus =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz";
in {
  "secrets.age".publicKeys = [ marcus ];
  "vaultwarden.age".publicKeys = [ marcus ];
  "miniflux.age".publicKeys = [ marcus ];
  "transmission.age".publicKeys = [ marcus ];
  "prompass.age".publicKeys = [ marcus ];
  "promtail.age".publicKeys = [ marcus ];
  "ha-bearer.age".publicKeys = [ marcus ];
  "nixAccessTokens.age".publicKeys = [ marcus ];
}

