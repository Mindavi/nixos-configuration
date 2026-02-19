{ pkgs, config, ... }:
let
  #subnet = "10.0.2.0/24";
  subnet = "192.168.2.0/24";
  subnetWireguardIpv6 = "fd37:191a:d082:555::1/96";
in
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      subnet
      subnetWireguardIpv6
    ];
  };
}
