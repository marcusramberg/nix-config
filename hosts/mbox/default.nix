{ pkgs, config, modulesPath, ... }:

{
  networking.hostName = "mbox";
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    # nativeSystemd = true;
    defaultUser = "marcus";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };
  systemd.services.nixs-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = [
        "sysinit.target"
        "systemd-tmpfiles-setup-dev.service"
        "systemd-tmpfiles-setup.service"
        "systemd-sysctl.service"
      ];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = [ "sysinit.target" ];
  };

  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  #  system.stateVersion = "22.11";
}
