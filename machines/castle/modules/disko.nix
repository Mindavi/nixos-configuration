{
  # HACK(Mindavi): not sure if this is the right way to go about this.
  # See open issue on disko repository: https://github.com/nix-community/disko/issues/192
  #fileSystems."/persist".neededForBoot = true;
  #fileSystems."/persist/save".neededForBoot = true;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
    # inspiration:
    # https://github.com/collinarnett/brew/tree/main/hosts/azathoth
    zpool = {
      zroot = {
        type = "zpool";
        # Single disk, no mode options.
        mode = "";
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
          xattr = "sa";

          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        #mountpoint = "/";
        #postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        # Use 4k block size: https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
        # for Samsung 980 'page size' is 16 KB, but how does that translate to sector size?
        options.ashift = "12";
        datasets = {
          # reserve some space to prevent being unable to delete files
          # https://github.com/yomaq/nix-config/blob/9e19c1a210edbaf446dcff2abafd061b3748b909/modules/hosts/zfs/disks/nixos.nix#L311-L320
          reserved = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
              reservation = "20GiB";
            };
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = "zfs snapshot zroot/nix@empty";
          };
          #persist = {
          #  type = "zfs_fs";
          #  mountpoint = "/persist";
          #  options.mountpoint = "/persist";
          #  options."com.sun:auto-snapshot" = "false";
          #  postCreateHook = "zfs snapshot zroot/persist@empty";
          #};
          #persistSave = {
          #  type = "zfs_fs";
          #  mountpoint = "/persist/save";
          #  options.mountpoint = "/persist/save";
          #  options."com.sun:auto-snapshot" = "false";
          #  postCreateHook = "zfs snapshot zroot/persistSave@empty";
          #};
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zroot/root@empty";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "/home";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zroot/home@empty";
          };
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options = {
              mountpoint = "/tmp";
              sync = "disabled";
            };
          };
        };
      };
    };
  };
}
