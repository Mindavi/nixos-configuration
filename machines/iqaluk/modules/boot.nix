{
  lib,
  pkgs,
  ...
}:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    # 2026-05-18: initrd 42MiB + bzImage 14MiB
    configurationLimit = 20;
    editor = false;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.kernelParams = [ ];
  boot.kernel.sysctl = {
    # https://www.kernel.org/doc/html/latest/mm/overcommit-accounting.html
    "vm.overcommit_memory" = "0";
  };

  # e.g. platformio and element use this, so make sure this is enabled.
  security.unprivilegedUsernsClone = true;
}
