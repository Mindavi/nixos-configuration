{ config, pkgs, ... }:

{
  services.owncast = {
    enable = true;
    port = 8080;
    rtmp-port = 1935;
  };

  networking.firewall.allowedTCPPorts = [
    config.services.owncast.rtmp-port
  ];
}
