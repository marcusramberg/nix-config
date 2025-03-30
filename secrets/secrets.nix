let
  marcus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz";
  machines = [
    # mrack01
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhHhpeSvc8H5LrELJZBoOaNODjv3H4sJO7Z7dwZFKD7aS7qxaoces63tclYmadupq1lbnOKCaW+kr6vgM/DmjJLdOzsC/Oqlxh9oEVFbjsivi0eCK3sbj9BzEchm5wJwaQoyQlyVPbWw6cIN33CTpLpjxhZppHfaFv6zpdfTc/uAclTRpYeG8W3PuLf0UwV5wmzKfHVtDqTSgrpvOB+a9XyfxSU9DvNX1yvdi/k8Mcnju7jXPjKL1xsSlB+X2MclFqTl71zDdcPYEGPQuXat8mUoq0dK+2wf4MG4tyh1itt9tNpxXeEKkfm+vE9JF5Wb8S3fc6A74hoorKex25wq904y9MlcnLP+KipyD39yVJxl1nCJXgO2RS61hErSwayjgYCIhBEA3WstCg9ZO8J4aAl76Xda/24nbFuFMgrx7+LI8rqLrxLDkCGNMMd9rZ5sWhKLj3O9SQKTukeWqin8/XlT1wrYd4LwgynKNbFEzlbzLLwdKFjtL1saEorOmsnQ/gHR+BN63yZy0q1zKYEG2dWsVXF7+Uex263mI8BlHIaFXMvCJVIzZfv3RKzPbrdwFZ7wmU9mSUIRfBeAH3gf9ys3WFSnPfLcpd8JcsAQFOh5UbJJoBpr/zLFtcoODPwDt8U5NwNSou0co++JwGWLGpmQSrIoEsOW1M2eCHaR5jBw==
"
  ];
in
{
  "appdaemonToken.age".publicKeys = [ marcus ] ++ machines;
  "borgbackup.age".publicKeys = [ marcus ] ++ machines;
  "cloudflareToken.age".publicKeys = [ marcus ] ++ machines;
  "ha-bearer.age".publicKeys = [ marcus ] ++ machines;
  "immich.age".publicKeys = [ marcus ] ++ machines;
  "k3s-token.age".publicKeys = [ marcus ] ++ machines;
  "leases.age".publicKeys = [ marcus ] ++ machines;
  "miniflux.age".publicKeys = [ marcus ] ++ machines;
  "mosquittoPass.age".publicKeys = [ marcus ] ++ machines;
  "networks.age".publicKeys = [ marcus ] ++ machines;
  "nixAccessTokens.age".publicKeys = [ marcus ] ++ machines;
  "phone-pin.age".publicKeys = [ marcus ] ++ machines;
  "picserver.age".publicKeys = [ marcus ] ++ machines;
  "prompass.age".publicKeys = [ marcus ] ++ machines;
  "promtail.age".publicKeys = [ marcus ] ++ machines;
  "secrets.age".publicKeys = [ marcus ] ++ machines;
  "transmission.age".publicKeys = [ marcus ] ++ machines;
  "vaultwarden.age".publicKeys = [ marcus ] ++ machines;
}
