{ pkgs, config, ... }:
{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
        };
        websecure = {
          address = ":443";
        };
      };
      api.dashboard = true;
      accesslog = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

