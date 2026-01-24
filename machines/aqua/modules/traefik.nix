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
  range_wireguard_ipv4 = "172.16.1.0/24";
  # TODO(ricsch): This range is quite arbitrary.
  range_wireguard_ipv6 = "fd37:191a:d082:555::1/96";
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
        middlewares.localhost-allowlist.ipallowlist.sourcerange = lib.concatStringsSep ", " [
          "127.0.0.1/32"
          "[::1]"
        ];

        ### Internal API
        # Disabled because it clashes with Home Assistant.
        # routers.api = {
        #   # https://doc.traefik.io/traefik/routing/routers/#entrypoints
        #   # If not specified, HTTP routers will accept requests from all EntryPoints in the list of default EntryPoints.
        #   entrypoints = "web";
        #   rule = "PathPrefix(`/traefik`) || PathPrefix(`/api`)";
        #   service = "api@internal";
        # };

        ### Home assistant
        routers.homeassistant = {
          # Home assistant doesn't support routing using a subpath.
          # https://community.home-assistant.io/t/accessing-home-assistant-through-reverse-proxy-with-custom-path/355792
          # https://github.com/home-assistant/core/issues/21113
          # https://community.home-assistant.io/t/configurable-webroot/516
          # https://github.com/home-assistant/core/issues/805
          rule = "Host(`hass.aqua`) || Host(`aqua.local`) || ClientIP(`${range_internal1}`) || ClientIP(`${range_wireguard_ipv4}`) || ClientIP(`${range_wireguard_ipv6}`) || Host(`aqua.lan`) || Host(`hass.home.arpa`)";
          # Give this route the lowest priority to ensure other routes are always matched first.
          # Otherwise e.g. the hydra route would not be chosen with http://aqua.local/hydra.
          priority = 1;
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
        };
        services.homeassistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
            }
          ];
        };

        routers.homeassistant_prometheus = {
          rule = "PathPrefix(`/api/prometheus`)";
          service = "homeassistant";
          middlewares = [
            "localhost-allowlist"
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
          rule = "Host(`grafana.aqua`) || PathPrefix(`/grafana`) || Host(`grafana.home.arpa`)";
          service = "grafana";
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
          rule = "PathPrefix(`/dashboard/`) && !(Host(`traefik.aqua`) || Host(`traefik.localhost`)) || Host(`dashboard.home.arpa`)";
          service = "dashboard";
          middlewares = [
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
          rule = "Host(`music-assistant.aqua`) || Host(`music-assistant.aqua.local`) || Host(`music-assistant.aqua.lan`)  || Host(`music-assistant.home.arpa`)";
          service = "music-assistant";
        };
        services.music-assistant = {
          loadBalancer.servers = [
            {
              url = "http://localhost:8095";
            }
          ];
        };

        ### Syncthing
        middlewares.syncthing-stripprefix.stripprefix.prefixes = "/syncthing";
        routers.syncthing = {
          rule = "PathPrefix(`/syncthing`)";
          service = "syncthing";
          middlewares = [
            "syncthing-stripprefix"
          ];
        };
        services.syncthing = {
          loadBalancer.servers = [
            {
              url = "http://${config.services.syncthing.guiAddress}";
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
