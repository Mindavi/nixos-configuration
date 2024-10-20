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
      localbackup = {
        initialize = true;
        passwordFile = "/etc/nixos/secrets/restic-password";
        paths = [
          "/home/rick/Pass"
        ];
        repository = "/run/media/rick/ricks_data/restic/Pass";
      };
    };
  };
}
