{
  boot.supportedFilesystems = [ "zfs" ];
  # Recommended to be disabled, default enabled for backwards compat reasons.
  boot.zfs.forceImportRoot = false;
  # TODO(Mindavi): should we enable this?
  services.zfs.autoSnapshot.enable = false;
  services.zfs.autoScrub.enable = true;

  # Consider setting TimeoutStopFailureMode to prevent ZFS stopping system shutdown if any issues occur.
}
