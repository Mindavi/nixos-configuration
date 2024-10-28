{ pkgs, config, ... }:
let
  # use 8000 for testing since it's easier to open up for now
  webport = 80;
  websecureport = 8001; # use 8001 for experimentation
in
{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log.level = "DEBUG";
      entryPoints = {
        web = {
          address = ":${toString webport}";
          # https://doc.traefik.io/traefik/routing/routers/#entrypoints
          # If not specified, HTTP routers will accept requests from all EntryPoints in the list of default EntryPoints.
          asDefault = true;
        };
        websecure = {
          address = ":${toString websecureport}";
        };
      };
      api.dashboard = true;
      accesslog = true;
      #certificatesResolvers.le.acme = {
      #email = "rol3517@gmail.com";
      #storage = "letsencrypt/acme.json";  # FIXME: probably somewhere in /var/?
      #httpChallenge.entryPoint = "web";
      #};
    };
    dynamicConfigOptions = {
      http = {
        routers.api = {
          # https://doc.traefik.io/traefik/routing/routers/#entrypoints
          # If not specified, HTTP routers will accept requests from all EntryPoints in the list of default EntryPoints.
          entrypoints = "web";
          # TODO: change Host rule to traefik.rickvanschijndel.eu
          rule = "(Host(`traefik.aqua`) || Host(`traefik.localhost`)) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
          service = "api@internal";
          middlewares = "internal-whitelist";
        };
        # TODO: change source range to 192.168.2.0/24
        middlewares.internal-whitelist.ipwhitelist.sourcerange = "192.168.1.0/24";

        routers.homeassistant = {
          # TODO: change to home.rickvanschijndel.eu
          rule = "Host(`home.aqua`) || Host(`home.localhost`) || ClientIP(`192.168.1.0/24`)";
          # TODO: change to websecure
          entrypoints = "web";
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
          middlewares = "internal-whitelist";
        };
        services.homeassistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:8123";
            }
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    webport
    websecureport
  ];
}
