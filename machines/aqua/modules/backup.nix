{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    rclone
    restic
  ];
  services.restic = {
    backups = {
      rsyncnet_samba = {
        initialize = true;
        passwordFile = "/etc/nixos/secrets/restic-password";
        paths = [
          "/var/data/samba/copydrive"
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-monthly 12"
          "--keep-yearly 25"
        ];
        repository = "sftp:zh4793@zh4793.rsync.net:restic/samba";
        timerConfig = {
          OnCalendar = "00:30";
          Persistent = true;
          RandomizedDelaySec = "3h";
        };
      };
    };
  };
  programs.ssh.extraConfig = ''
    Host zh4793.rsync.net
      IdentityFile /root/.ssh/id_ed25519_restic
      User zh4793
  '';
}
