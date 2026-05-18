{
  config,
  pkgs,
  lib,
  ...
}:

let
  # https://wiki.nixos.org/wiki/ZFS
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in

{
  boot.kernelPackages = latestKernelPackage;
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
  # Consider setting TimeoutStopFailureMode to prevent ZFS stopping system shutdown if any issues occur.
}
