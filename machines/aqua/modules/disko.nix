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
        rootfsOptions = {
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
          storage = {
            type = "zfs_fs";
            mountpoint = "/storage";
            # TODO(Mindavi): fill in further...
          };
        };
      };
    };
  };
}
