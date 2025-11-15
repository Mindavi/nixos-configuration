{
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  # Recommended to be disabled, default enabled for backwards compat reasons.
  # Make sure to export the pool after nixos-install to ensure it can be imported.
  # The hostId will be different so without exporting systemd will refuse to import the pool.
  boot.zfs.forceImportRoot = false;
  services.zfs = {
    # TODO(Mindavi): should we enable this?
    autoSnapshot.enable = false;
    autoScrub.enable = true;
    trim.enable = true;
  };
}
