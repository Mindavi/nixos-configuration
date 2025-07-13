{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
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
        # Single disk, no mode options.
        mode = "";
        rootfsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          xattr = "sa";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        # Use 4k block size: https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
        # for Samsung 980 'page size' is 16 KB, but how does that translate to sector size?
        options.ashift = "12";
        datasets = {
          storage = {
            type = "zfs_fs";
            mountpoint = "/";
            # TODO(Mindavi): fill in further...
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };
}
