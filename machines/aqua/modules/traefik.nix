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
    dynamicConfigOptions = {
      http = {
        routers.api = {
          entrypoints = "web";
          rule = "Host(`localhost`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
          service = "api@internal";
          middlewares = "internal-whitelist";
        };
        middlewares.internal-whitelist.ipwhitelist.sourcerange = "10.0.2.0/24";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

