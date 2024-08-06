{ lib, pkgs, config, ... }:
let
  ginlong-monitor = (pkgs.callPackage ./pkgs/ginlong-monitor {});
in
{
  environment.systemPackages = with pkgs; [
    ginlong-monitor
  ];
  networking.firewall.allowedTCPPorts = [ 9999 ];
  systemd.services.solar-inverter = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    description = "solar inverter listener daemon";
    serviceConfig = {
      Type = "exec";
      ExecStart = "${ginlong-monitor}/bin/ginlongmonitor";
      DynamicUser = "yes";
      Restart = "on-failure";
      RestartSec = "10s";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };
}
