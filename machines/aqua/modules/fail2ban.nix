{ pkgs, config, ... }:
let
  #subnet = "10.0.2.0/24";
  subnet = "192.168.2.0/24";
  subnetWireguard = "172.16.1.0/24";
in
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      subnet
      subnetWireguard
    ];
  };
}
