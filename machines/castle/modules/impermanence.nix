{ pkgs, ... }:
{
  environment.persistence."/persist" = {
    directories = [
      "/var/cache/restic-backups-data"
      "/var/cache/restic-backups-state"
      "/var/log"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/nix/netrc"
    ];
  };
  #environment.persistence."/persist/save" = {
  #  users.rick = {
  #    directories = [
  #      "Documents"
  #      "Downloads"
  #      "Pictures"
  #      "Videos"
  #      {
  #        directory = ".config/sops/age/";
  #        mode = "0700";
  #      }
  #      {
  #        directory = ".ssh";
  #        mode = "0700";
  #      }
  #    ];
  #    files = [
  #      ".bash_history"
  #    ];
  #  };
  #};
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.services.rollback = {
    description = "Rollback root filesystem to a pristine state";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-zroot.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zroot/local/root@empty && echo " >> >> Rollback Complete << <<"
    '';
  };
}
