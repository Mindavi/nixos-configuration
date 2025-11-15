{
  # HACK(Mindavi): not sure if this is the right way to go about this.
  # See open issue on disko repository: https://github.com/nix-community/disko/issues/192
  #fileSystems."/persist".neededForBoot = true;
  #fileSystems."/persist/save".neededForBoot = true;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL1W144708T";
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
    # https://github.com/nix-community/disko/blob/master/example/zfs-encrypted-root.nix
    # https://gitlab.com/misuzu/nixos-configuration/-/blob/a5a836e25b81f3f0ede57e68e7884e42aa2b0769/hosts/akane/disko-config.nix
    # https://discourse.nixos.org/t/zfs-with-disko-faluire-to-import-zfs-pool/61988
    # https://github.com/NixOS/infra/blob/main/builders/disk-layouts/efi-zfs-raid0.nix
    # encrypted btrfs: https://github.com/ryan4yin/nix-config/blob/main/hosts/idols-aquamarine/disko-fs.nix
    # https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/disks/btrfs-luks-impermanence-disk.nix
    zpool = {
      zroot = {
        type = "zpool";
        # Single disk, no mode options.
        mode = "";
        # From disko example, possibly helps with issues importing zroot?
        options.cachefile = "none";
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
          xattr = "sa";
          #encryption = "aes-256-gcm";
          #keyformat = "passphrase";
          #keylocation = "prompt";
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
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zroot/root@empty";
          };
          "root/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = "zfs snapshot zroot/root/nix@empty";
          };
          "root/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zroot/root/home@empty";
          };
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options = {
              mountpoint = "legacy";
              sync = "disabled";
            };
          };
        };
      };
    };
  };
}
