{ pkgs, config, ... }:
let
  subnetLan = "192.168.178.0/24";
  subnetWireguard = "172.16.1.0/24";
in
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      subnetLan
      subnetWireguard
    ];
  };
}
