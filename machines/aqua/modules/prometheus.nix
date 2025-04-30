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
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "aqua:${toString config.services.prometheus.exporters.node.port}"
              "172.16.1.2:9100"
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
              "aqua:${toString config.services.prometheus.exporters.restic.port}"
            ];
          }
        ];
      }
    ];
  };
}
