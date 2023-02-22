{ config, lib, pkgs, ... }:
{
  hardware.rtl-sdr.enable = true;
  environment.systemPackages = with pkgs; [
    rtl_433
  ];

  # This module also requires the following settings:
  # users.users.<username>.extraGroups = [ "plugdev" ];
}

