{ lib, pkgs, config, ... }:
{
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  environment.systemPackages = with pkgs; [
    rtl_433
  ];
  systemd.services.rtl_433 = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    description = "rtl_433 listener daemon";
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.rtl_433}/bin/rtl_433 -F json -F mqtt";
      DynamicUser = "yes";
      SupplementaryGroups = [ "plugdev" ];
      Restart = "on-failure";
      RestartSec = "10s";
      ProtectSystem = "strict";
      PrivateHome = true;
      PrivateTmp = true;
    };
  };
}
