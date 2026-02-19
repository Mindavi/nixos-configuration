{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          # To maybe detect why the home assistant keeps dropping connections.
          "tcpstat"
        ];
      };
    };
    globalConfig.scrape_interval = "15s";
    # Use traefik for proxying.
    listenAddress = "127.0.0.1";
    port = 9090;
    webExternalUrl = "/prometheus/";
    # Required because we read a credential file using sops that's not available from the nix sandbox.
    checkConfig = "syntax-only";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "aqua:${toString config.services.prometheus.exporters.node.port}"
              "[fd37:191a:d082:0555::2]:9100"
            ];
          }
        ];
      }
      {
        job_name = "hydra_web_server";
        static_configs = [
          {
            targets = [
              "aqua:3000"
            ];
          }
        ];
      }
      {
        job_name = "hydraqueuerunner";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [
              "aqua:9198"
            ];
          }
        ];
      }
      {
        job_name = "hydra_queue_runner";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [
              "aqua:9200"
            ];
          }
        ];
      }
      {
        job_name = "home_assistant";
        metrics_path = "/api/prometheus";
        bearer_token_file = config.sops.secrets."prometheus/homeassistant".path;
        static_configs = [
          {
            targets = [
              "aqua:8123"
            ];
          }
        ];
      }
      {
        job_name = "rtl_433";
        fallback_scrape_protocol = "PrometheusText0.0.4";
        static_configs = [
          {
            targets = [
              "aqua:8433"
            ];
          }
        ];
      }
      {
        job_name = "restic";
        static_configs = [
          {
            targets = [
              # "aqua:${toString config.services.prometheus.exporters.restic.port}"
            ];
          }
        ];
      }
    ];
  };
}
