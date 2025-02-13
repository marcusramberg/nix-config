let
  marcus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz";
in
{
  "appdaemonToken.age".publicKeys = [ marcus ];
  "borgbackup.age".publicKeys = [ marcus ];
  "cloudflareToken.age".publicKeys = [ marcus ];
  "ha-bearer.age".publicKeys = [ marcus ];
  "immich.age".publicKeys = [ marcus ];
  "k3s-token.age".publicKeys = [ marcus ];
  "leases.age".publicKeys = [ marcus ];
  "miniflux.age".publicKeys = [ marcus ];
  "mosquittoPass.age".publicKeys = [ marcus ];
  "nixAccessTokens.age".publicKeys = [ marcus ];
  "phone-pin.age".publicKeys = [ marcus ];
  "picserver.age".publicKeys = [ marcus ];
  "prompass.age".publicKeys = [ marcus ];
  "promtail.age".publicKeys = [ marcus ];
  "secrets.age".publicKeys = [ marcus ];
  "transmission.age".publicKeys = [ marcus ];
  "vaultwarden.age".publicKeys = [ marcus ];
}
