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
  # TODO(mindavi): figure out how to automatically start backup when disk is plugged in.
  services.restic = {
    backups = {
      localbackup = {
        # Otherwise it will create the folder even if the drive is not mounted.
        # TODO(mindavi): only run when disk is mounted...
        initialize = false;
        passwordFile = "/etc/nixos/secrets/restic-password";
        paths = [
          "/home/rick/Pass"
        ];
        exclude = [
          ".ttxfolder"
          ".stfolder*"
        ];
        repository = "/run/media/rick/ricks_data/restic/Pass";
        timerConfig = null;
      };
      dropbox_pass = {
        initialize = true;
        passwordFile = "/etc/nixos/secrets/restic-password";
        paths = [
          "/home/rick/Pass"
        ];
        exclude = [
          ".ttxfolder"
          ".stfolder*"
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-monthly 12"
          "--keep-yearly 5"
        ];
        repository = "rclone:dropbox:restic/Pass";
        rcloneConfigFile = "/home/rick/.config/rclone/rclone.conf";
        timerConfig = {
          OnCalendar = "02:30";
          Persistent = true;
          RandomizedDelaySec = "3h";
        };
      };
    };
  };
}
