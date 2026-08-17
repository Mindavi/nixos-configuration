{
  lib,
  pkgs,
  ...
}:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = false;
    # 2026-05-18: initrd 42MiB + bzImage 14MiB
    configurationLimit = 20;
    # Prevent getting a root shell by passing kernel parameters.
    editor = false;
    # Is not signed, so we cannot boot it with secure boot enabled.
    # https://github.com/nix-community/lanzaboote/issues/273
    # Keeping enabled since it can be useful to temporarily disable secure boot and run memtest.
    memtest86.enable = true;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.kernelParams = [ ];
  boot.kernel.sysctl = {
    # https://www.kernel.org/doc/html/latest/mm/overcommit-accounting.html
    "vm.overcommit_memory" = "0";
  };

  # The system will try to boot as far as possible even if mounting (or other services) fail.
  # Otherwise it will be dropped in an emergency shell (without SSH access).
  systemd.enableEmergencyMode = false;
}
