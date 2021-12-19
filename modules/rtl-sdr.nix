{ config, lib, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;
  services.udev.packages = [ pkgs.rtl-sdr ];
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];

  # This module also requires the following settings:
  # users.users.<username>.extraGroups = [ "plugdev" ];
}

