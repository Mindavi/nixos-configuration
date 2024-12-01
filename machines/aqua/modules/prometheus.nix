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
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "nixos-asus_node";
        static_configs = [
          {
            targets = [ "172.16.1.2:9100" ];
          }
        ];
      }
      {
        job_name = "aqua_hydra_web_server";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [ "aqua:9198" ];
          }
        ];
      }
      {
        job_name = "aqua_hydra_queue_runner";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [ "aqua:9200" ];
          }
        ];
      }
      {
        job_name = "nixos-asus_hydra_web_server";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [ "172.16.1.2:9198" ];
          }
        ];
      }
      {
        job_name = "nixos-asus_hydra_queue_runner";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [ "172.16.1.2:9200" ];
          }
        ];
      }
      {
        job_name = "rtl_433";
        static_configs = [
          {
            # Don't use `aqua`, it will try to use ipv6 and I think rtl_433 doesn't support that?
            # At least, we get errors like:
            # Dec 01 22:25:39 aqua prometheus[814]: time=2024-12-01T22:25:39.838+01:00 level=ERROR source=scrape.go:1585 msg="Failed to determine correct type of scrape target." component="scrape manager" scrape_pool=rtl_433 target=http://aqua:8433/metrics content_type="" fallback_media_type="" err="non-compliant scrape target sending blank Content-Type and no fallback_scrape_protocol specified for target"
            targets = [ "127.0.0.1:8433" ];
            # fallback_scrape_protocol = "PrometheusText0.0.4";
          }
        ];
      }
    ];
  };
}
