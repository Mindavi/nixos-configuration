{ pkgs, config, ... }:
let
  subnet = "192.168.1.0/24";
  subnetWireGuardIpv6 = "fd37:191a:d082:555::1/64";
in
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      subnet
      subnetWireGuardIpv6
    ];
  };
}
