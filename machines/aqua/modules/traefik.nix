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
  range_wireguard_ipv6 = "fd37:191a:d082:555::1/64";
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
          "127.0.0.0/8"
          "::1"
        ];

        ### Home assistant
        routers.homeassistant = {
          # Home assistant doesn't support routing using a subpath.
          # https://community.home-assistant.io/t/accessing-home-assistant-through-reverse-proxy-with-custom-path/355792
          # https://github.com/home-assistant/core/issues/21113
          # https://community.home-assistant.io/t/configurable-webroot/516
          # https://github.com/home-assistant/core/issues/805
          rule = "Host(`hass.aqua`) || Host(`aqua.local`) || ClientIP(`${range_wireguard_ipv6}`) || Host(`hass.home.arpa`) || Host(`home-assistant.home.arpa`) || ClientIP(`${range_internal1}`) || Host(`hass-local.home.arpa`)";
          # Give this route the lowest priority to ensure other routes are always matched first.
          # Otherwise e.g. the hydra route would not be chosen with http://aqua.local/hydra.
          priority = 1;
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
        routers.hydra = {
          rule = "Host(`hydra.home.arpa`)";
          service = "hydra";
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
          rule = "Host(`prometheus.home.arpa`)";
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
          rule = "Host(`grafana.home.arpa`)";
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
        routers.dashboard = {
          rule = "Host(`dashboard.home.arpa`)";
          service = "dashboard";
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
          rule = "Host(`zigbee2mqtt.home.arpa`)";
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
          rule = "Host(`music-assistant.home.arpa`) || Host(`mass-local.home.arpa`)";
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
        routers.syncthing = {
          rule = "Host(`syncthing.home.arpa`)";
          service = "syncthing";
        };
        services.syncthing = {
          loadBalancer.servers = [
            {
              url = "http://${config.services.syncthing.guiAddress}";
            }
          ];
        };

        ### Immich
        routers.immich = {
          rule = "Host(`photos.home.arpa`)";
          service = "immich";
        };
        services.immich = {
          loadBalancer.servers = [
            {
              url = "http://localhost:${toString config.services.immich.port}";
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
