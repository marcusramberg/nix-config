# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = false;
    };
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options macsmc_hwmon melt_my_mac=1
    '';
    postBootCommands = ''
      echo 1100 > /sys/class/hwmon/hwmon0/fan1_target
      echo 1100 > /sys/class/hwmon/hwmon0/fan2_target
    '';
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
    asahi-nvram
    asahi-btsync
    asahi-wifisync
  ];

  hardware = {
    keyboard.dual-caps.enable = true;
    asahi = {
      peripheralFirmwareDirectory = ./firmware;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      withRust = true;
    };
  };

  networking = {
    hostName = "mstudio";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnsupportedSystem = true;
  # Enable the X11 windowing system.
  profiles = {
    autoupgrade.enable = true;
    dockerHost.enable = true;
    desktop.enable = true;
    hyprland.enable = true;
  };

  services = {
    libinput.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig = {
        pulse = [
          {
            cmd = "set-default-sink";
            args = "54";
          }
          {
            cmd = "load-module";
            args = "module-switch-on-connect";
          }
        ];
      };
    };
  };

  users.users.marcus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
