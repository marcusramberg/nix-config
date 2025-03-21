_: {
  # Enable local linux vm builder
  nix.linux-builder.enable = false;
  # Use mbox to build x86_64-linux
  nix.buildMachines = [
    {
      sshUser = "marcus";
      sshKey = "/etc/nix/builder_ed25519";
      system = "x86_64-linux";
      supportedFeatures = [
        "kvm"
        "benchmark"
        "big-parallel"
      ];
      maxJobs = 8;
    }
  ];
}
