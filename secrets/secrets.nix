let
  marcus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqWWPb0DqvTwAJKd0Nb/MOdplnTJgxQBSGbJkL2S+nz";
  machines = [
    # mrack01
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhHhpeSvc8H5LrELJZBoOaNODjv3H4sJO7Z7dwZFKD7aS7qxaoces63tclYmadupq1lbnOKCaW+kr6vgM/DmjJLdOzsC/Oqlxh9oEVFbjsivi0eCK3sbj9BzEchm5wJwaQoyQlyVPbWw6cIN33CTpLpjxhZppHfaFv6zpdfTc/uAclTRpYeG8W3PuLf0UwV5wmzKfHVtDqTSgrpvOB+a9XyfxSU9DvNX1yvdi/k8Mcnju7jXPjKL1xsSlB+X2MclFqTl71zDdcPYEGPQuXat8mUoq0dK+2wf4MG4tyh1itt9tNpxXeEKkfm+vE9JF5Wb8S3fc6A74hoorKex25wq904y9MlcnLP+KipyD39yVJxl1nCJXgO2RS61hErSwayjgYCIhBEA3WstCg9ZO8J4aAl76Xda/24nbFuFMgrx7+LI8rqLrxLDkCGNMMd9rZ5sWhKLj3O9SQKTukeWqin8/XlT1wrYd4LwgynKNbFEzlbzLLwdKFjtL1saEorOmsnQ/gHR+BN63yZy0q1zKYEG2dWsVXF7+Uex263mI8BlHIaFXMvCJVIzZfv3RKzPbrdwFZ7wmU9mSUIRfBeAH3gf9ys3WFSnPfLcpd8JcsAQFOh5UbJJoBpr/zLFtcoODPwDt8U5NwNSou0co++JwGWLGpmQSrIoEsOW1M2eCHaR5jBw=="
    # mhub
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+qgRG8hGXtz/713ZkGrMYOSW/DD5WDJsPsLX8JllP2tBYz7HeApHIqKU37Rya/eCWC6BA424VAFpjdBNkE37T7XD0FDIX07qYwFYC9tAaEoF/Lhs/vlINS4gFalLBcSQl+nrZF127DZRpmSJ1K8ugRqwK1ETF7KCAVYXzB8yQxTcNX/tCedhwe2R6A1XEAltUhif1waYy2V6NIZ5l4aZOzS/vAmGsxBzcNaDpk9Ins7qxu5ypACVFsnqNYhKACQA+5rwUpHdfrwCYXEC4ndSOC9LduvAejIt13ZPPsCANFqsL+Ygw2U0nqhenYGj1XzJfBotKIOPu4X6V/yqlDznIvRavo3Pj39C+EQYVEOttibj+Vlk0qBpd6VreRDJZO/fPgMIrDe80IgQ9pM8T2vNUfAXBzTP4DRn4m6gQ90Jn9846+dx7e9xrPGCTW8lcYPUePUa/qL57QgMo64ZtKfqZX8fECjdb8xV41F+xlNk3+IyepWvyUExluSFcH1PMdiAnle46Qa+XnqwR7wHAOId+NM1XzuxyQ8p7KYK3Vn8RPx02A0XarEvlK+564bH8jVsxBSR+VXZVOHH7dvSMB6GoWXiujv8n6nQdzB7/W8hnatSqPB3LaJDviTWyRV5JvKVo7S5IipbavzC9BgC9BXoMDPBZo47hFfem75c+vfq77w=="
    # mcloud
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD2WuBWIT81TgS3uX9i4djuVNAvkSkh++hqeOL4pR+v+h5iSg/5Zpji9+8pvhWmnTmdcmPI8Y74qE7yIqsbg15NCzhRf8F/sPT5ZgkEvdEbXg/5PC9OyoRqpWs/T3n5YdyMj+no/16nJmpUQ/z8wBtMTwj0toTL9uhcYg+ssOavz0L0ZZpnlO98XuxiOVOjUdwp8IkT5kSD2qwmxpECmBM+Yv36/ZO8+BznVgSlVGR4NHr3F04VNZsj/UbBTsN8jULqQSXAE/vT/My+cYLxcnP5FiDYNQJniLne05r5U8THQ4JCnA0yqOssZiSji+Qn4EKU4mq4LjBGb06H/eXvx4OFibvJ33R8nXwu3Vs8Grl8VKb5bPHyzUPZsSd90cxmeNmOlc1Bu3n6/+2lSwYEWCwVvjc2p1lDFEuyXNyxTn+wqU8sxjyA0V+CDToWE1H/1I1VLQBsoaUavFx0cxjLYRl2OECr9uSK3hO0sJtZ015DsS1OyLCIcD0WywXyy7bNcy0="
  ];
in
{
  "appdaemonToken.age".publicKeys = [ marcus ] ++ machines;
  "authentik.age".publicKeys = [ marcus ] ++ machines;
  "borgbackup.age".publicKeys = [ marcus ] ++ machines;
  "caddy-secrets.age".publicKeys = [ marcus ] ++ machines;
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
  "wg-mrack01.age".publicKeys = [ marcus ] ++ machines;
}
