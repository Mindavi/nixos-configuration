{ config, pkgs, ... }:

{
  services.owncast = {
    enable = true;
    port = 8080;
    rtmp-port = 1935;
  };

  networking.firewall.allowedTCPPorts = [
    1935
    # TODO(Mindavi): use traefik instead
    8080
  ];
}
