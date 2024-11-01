{ pkgs, config, ... }:
let
  # use 8000 for testing since it's easier to open up for now
  webport = 80;
  websecureport = 8001; # use 8001 for experimentation
  range_internal = "192.168.1.0/24";
  range_wireguard = "172.16.1.0/24";
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
          middlewares = "internal-allowlist";
        };
        middlewares.internal-allowlist.ipallowlist.sourcerange = lib.concatStringsSep ", " [
          "127.0.0.1/32"
          range_internal
          range_wireguard
        ];

        middlewares.home-assistant-stripprefix.stripprefix.prefixes = "/hass";
        routers.homeassistant = {
          # Home assistant doesn't support routing using a subpath.
          # https://community.home-assistant.io/t/accessing-home-assistant-through-reverse-proxy-with-custom-path/355792
          # https://github.com/home-assistant/core/issues/21113
          # https://community.home-assistant.io/t/configurable-webroot/516
          rule = "Host(`hass.aqua`))";
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
          middlewares = [
            "internal-allowlist"
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
        # https://hydra.nixos.org/build/276327056/download/1/hydra/configuration.html#serving-behind-reverse-proxy
        middlewares.hydra-prefix-header.headers.customrequestheaders.X-Request-Base = "/hydra";
        routers.hydra = {
          rule = "Host(`hydra.aqua`) || PathPrefix(`/hydra`))";
          #tls = true;
          #tls.certresolver = "le";
          service = "hydra";
          middlewares = [
            "internal-allowlist"
            "hydra-stripprefix"
            "hydra-prefix-header"
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
