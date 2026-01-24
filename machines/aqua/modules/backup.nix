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
          "/var/lib/zigbee2mqtt"
          "/storage/documents"
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

  # Unit is failing on aqua.
  # Apr 03 07:54:54 aqua prometheus-restic-exporter-start[209376]: 2025-04-03 07:54:54 ERROR    Unable to collect metrics from Restic. Exception: Error executing restic snapshot command: {"message_type":"exit_error","code":1,"message":"Fatal: unable to open repository at sftp:zh4793@zh4793.rsync.net:restic/samba: exec: \"ssh\": executable file not found in $PATH"}  Exit code: 1

  # 2025-04-30 22:14:17 ERROR
  # Unable to collect metrics from Restic. Exception: Error executing restic snapshot command: subprocess ssh: hostkeys_find_by_key_hostfile: hostkeys_foreach failed for
  # /home/rick/.ssh/known_hosts: Permission denied subprocess ssh: Host key verification failed. {"message_type":"exit_error","code":1,"message"
  # :"Fatal: unable to open repository at sftp:zh4793@zh4793.rsync.net:restic/samba: unable to start the sftp session, error:
  # error receiving version packet from server: server unexpectedly closed connection: unexpected EOF"}  Exit code: 1
  services.prometheus.exporters.restic = {
    enable = false;
    port = 9753;
    repository = config.services.restic.backups.rsyncnet_samba.repository;
    refreshInterval = 60 * 60 * 6;
    passwordFile = config.services.restic.backups.rsyncnet_samba.passwordFile;
    # Prometheus is running on this machine.
    openFirewall = false;
    # TODO(Mindavi): Eh, is this ok? I'd like localhost (on IPv6?).
    # Should be supported, see https://github.com/prometheus/client_python/issues/791
    listenAddress = "::1";
  };

  systemd.services.prometheus-restic-exporter = {
    path = [
      pkgs.openssh
    ];
  };
}
