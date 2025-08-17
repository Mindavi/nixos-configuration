{
  disko.devices = {
    disk = {
      box_1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000NM017B-2TJ103_WWZ6YE7N";
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
      box_2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000NM017B-2TJ103_WWZ6YPF0";
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
      box_3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000NM017B-2TJ103_WWZ6Z0RK";
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
      box_4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000NM017B-2TJ103_WWZ6Z4AA";
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
    # TODO(Mindavi): ashift=12, noatime/atime=off
    zpool = {
      zroot = {
        type = "zpool";
        # raidz1 or use vdevs?
        mode = "raidz1";
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          atime = "off";
          xattr = "sa";
          mountpoint = "none";
        };
        # Use 4k block size: https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
        options.ashift = "12";
        datasets = {
          # For important documents that should be backed up.
          storage_documents = {
            type = "zfs_fs";
            mountpoint = "/storage/documents";
            # TODO(Mindavi): fill in further...
          };
          # For applications that require a lot of storage but where backing up is less important.
          storage_apps = {
            type = "zfs_fs";
            mountpoint = "/storage/apps";
          };
        };
      };
    };
  };
}
