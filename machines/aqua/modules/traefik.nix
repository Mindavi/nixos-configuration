{
  lib,
  config,
  ...
}:
let
  # use 8000 for testing since it's easier to open up for now
  webport = 80;
  websecureport = 8001; # use 8001 for experimentation
  range_internal1 = "192.168.1.0/24";
  range_internal2 = "192.168.178.0/24";
  range_wireguard = "172.16.1.0/24";
in
{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log.level = "INFO";
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
      api = {
        dashboard = false;
        basePath = "/traefik";
      };
      accesslog = true;
      #certificatesResolvers.le.acme = {
      #email = "rol3517@gmail.com";
      #storage = "letsencrypt/acme.json";  # FIXME: probably somewhere in /var/?
      #httpChallenge.entryPoint = "web";
      #};
    };
    dynamicConfigOptions = {
      http = {
        middlewares.internal-allowlist.ipallowlist.sourcerange = lib.concatStringsSep ", " [
          "127.0.0.1/32"
          range_internal1
          range_internal2
          range_wireguard
        ];

        ### Internal API
        # Disabled because it clashes with Home Assistant.
        # routers.api = {
        #   # https://doc.traefik.io/traefik/routing/routers/#entrypoints
        #   # If not specified, HTTP routers will accept requests from all EntryPoints in the list of default EntryPoints.
        #   entrypoints = "web";
        #   rule = "PathPrefix(`/traefik`) || PathPrefix(`/api`)";
        #   service = "api@internal";
        #   middlewares = "internal-allowlist";
        # };

        ### Home assistant
        routers.homeassistant = {
          # Home assistant doesn't support routing using a subpath.
          # https://community.home-assistant.io/t/accessing-home-assistant-through-reverse-proxy-with-custom-path/355792
          # https://github.com/home-assistant/core/issues/21113
          # https://community.home-assistant.io/t/configurable-webroot/516
          # https://github.com/home-assistant/core/issues/805
          rule = "Host(`hass.aqua`) || Host(`aqua.local`) || Host(`aqua.fritz.box`) || ClientIP(`${range_internal1}`) || ClientIP(`${range_wireguard}`) || ClientIP(`${range_internal2}`)";
          # Give this route the lowest priority to ensure other routes are always matched first.
          # Otherwise e.g. the hydra route would not be chosen with http://aqua.local/hydra.
          priority = 1;
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.homeassistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
            }
          ];
        };

        ### Hydra
        middlewares.hydra-stripprefix.stripprefix.prefixes = "/hydra";
        # https://hydra.nixos.org/build/276327056/download/1/hydra/configuration.html#serving-behind-reverse-proxy
        middlewares.hydra-prefix-header.headers.customrequestheaders.X-Request-Base = "/hydra";
        routers.hydra = {
          rule = "Host(`hydra.aqua`) || PathPrefix(`/hydra`)";
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
              url = "http://localhost:${toString config.services.hydra.port}";
            }
          ];
        };

        ### Prometheus
        routers.prometheus = {
          # https://blog.cubieserver.de/2020/configure-prometheus-on-a-sub-path-behind-reverse-proxy/
          rule = "Host(`prometheus.aqua`) || PathPrefix(`/prometheus`)";
          service = "prometheus";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.prometheus = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.prometheus.port}";
            }
          ];
        };

        ### Grafana
        routers.grafana = {
          rule = "Host(`grafana.aqua`) || PathPrefix(`/grafana`)";
          service = "grafana";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.grafana = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
            }
          ];
        };

        ### Dashboard
        middlewares.dashboard-stripprefix.stripprefix.prefixes = "/dashboard/";
        routers.dashboard = {
          rule = "PathPrefix(`/dashboard/`) && !(Host(`traefik.aqua`) || Host(`traefik.localhost`))";
          service = "dashboard";
          middlewares = [
            "internal-allowlist"
            "dashboard-stripprefix"
          ];
        };
        services.dashboard = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.glance.settings.server.port}";
            }
          ];
        };

        ### Zigbee2MQTT
        routers.zigbee2mqtt = {
          rule = "PathPrefix(`/zigbee2mqtt`)";
          service = "zigbee2mqtt";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.zigbee2mqtt = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.zigbee2mqtt.settings.frontend.port}";
            }
          ];
        };

        ### Music assistant
        routers.music-assistant = {
          rule = "Host(`music-assistant.aqua`)";
          service = "music-assistant";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.music-assistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:8095";
            }
          ];
        };

        ### Owncast
        # TODO(Mindavi): This is just temporary, don't worry too much about kind of leaking this.
        middlewares.owncast-auth.basicauth = {
          users = "livestream:$apr1$JUOgeXL6$oXoowCXNZpqbad347ZL8f1";
          # Otherwise it conflicts with the basic auth owncast serves on the admin endpoint.
          removeHeader = true;
        };
        routers.owncast_internet = {
          rule = "Host(`owncast.rickvanschijndel.eu`)";
          service = "owncast";
          middlewares = [
            "owncast-auth"
          ];
        };
        routers.owncast_trusted = {
          rule = "Host(`owncast.aqua`) || Host(`owncast-wg.aqua`)";
          service = "owncast";
          middlewares = [
            "internal-allowlist"
          ];
        };
        services.owncast = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.owncast.port}";
            }
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    webport
    # websecureport
  ];
}
