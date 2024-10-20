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
        initialize = true;
        passwordFile = "/etc/nixos/secrets/restic-password";
        paths = [
          "/home/rick/Pass"
        ];
        exclude = [
          ".ttxfolder"
          ".stfolder*"
        ];
        repository = "/run/media/rick/ricks_data/restic/Pass";
      };
    };
  };
}
