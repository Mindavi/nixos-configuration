{ pkgs, config, ... }:
let
  # use 8000 for testing since it's easier to open up for now
  webport = 80;
  websecureport = 8001; # use 8001 for experimentation
  range = "192.168.1.0/24";
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
        middlewares.internal-whitelist.ipwhitelist.sourcerange = range;

        middlewares.home-assistant-stripprefix.stripprefix.prefixes = "/hass";
        routers.homeassistant = {
          # TODO: change to home.rickvanschijndel.eu
          rule = "Host(`home.aqua`) || Host(`home.localhost`) || (ClientIP(`${range}`) && PathPrefix(`/hass`))";
          # TODO: change to websecure
          entrypoints = "web";
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
          middlewares = [
            "internal-whitelist"
            "home-assistant-stripprefix"
          ];
        };
        services.homeassistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:8123";
            }
          ];
        };
        middlewares.hydra-stripprefix.stripprefix.prefixes = "/hydra";
        routers.hydra = {
          rule = "Host(`hydra.aqua`) || Host(`hydra.localhost`) || (ClientIP(`${range}`) && PathPrefix(`/hydra`))";
          # TODO: change to websecure
          entrypoints = "web";
          #tls = true;
          #tls.certresolver = "le";
          service = "hydra";
          middlewares = [
            "internal-whitelist"
            "hydra-stripprefix"
          ];
        };
        services.hydra = {
          loadBalancer.servers = [
            {
              url = "http://localhost:3000";
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
