_: {
  # Enable local linux vm builder
  nix.linux-builder.enable = true;
  # Use mbox to build x86_64-linux
  nix.buildMachines = [{
    hostName = "mbox";
    sshUser = "marcus";
    sshKey = "/etc/nix/builder_ed25519";
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
    maxJobs = 8;
  }];
}
