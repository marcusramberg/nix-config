{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zspace";
              };
            };
          };
        };
      };
      sdb = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-2";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zspace";
              };
            };
          };
        };
      };
      sdc = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-3";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zspace";
              };
            };
          };
        };
      };
      sdd = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-4";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zspace";
              };
            };
          };
        };
      };
      ssd1 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:03:00.0-sas-phy3-lun-0";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      ssd2 = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:03:00.0-sas-phy5-lun-0";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "raidz1";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };

          var = {
            type = "zfs_fs";
            mountpoint = "/var";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
      zspace = {
        type = "zpool";
        mode = "raidz1";
        # Workaround: cannot import 'zroot': I/O error in disko tests
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/space";

        datasets = {
          backup = {
            type = "zfs_fs";
            mountpoint = "/backup";
            options."com.sun:auto-snapshot" = "true";
          };
          vms = {
            type = "zfs_fs";
            mountpoint = "/vms";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
