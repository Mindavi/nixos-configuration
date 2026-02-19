{ pkgs, config, ... }:
let
  subnetLan = "192.168.178.0/24";
  subnetWireGuardIpv6 = "fd37:191a:d082:555::1/96";
in
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      subnetLan
      subnetWireGuardIpv6
    ];
  };
}
