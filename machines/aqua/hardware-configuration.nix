# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      "${modulesPath}/installer/scan/not-detected.nix"
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

#  fileSystems."/nix" =
#    {
#      device = "/dev/disk/by-label/nix";
#      fsType = "ext4";
#      neededForBoot = true;
#      options = [ "noatime" ];
#    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [{
      device = "/dev/disk/by-label/nix-swap";
    }];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
