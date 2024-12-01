{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.prometheus = {
    enable = true;
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
        ];
      };
    };
    globalConfig.scrape_interval = "15s";
    # Don't expose outside laptop for now.
    # Firewall will handle this but this is extra protection if firewall is disabled for some reason.
    listenAddress = "127.0.0.1";
    port = 9090;
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
        job_name = "hydra";
        static_configs = [
          {
            # https://hydra.nixos.org/build/274637211/download/1/hydra/configuration.html#hydra-queue-runners-prometheus-service
            targets = [ "localhost:9198" ];
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
        job_name = "hydra_queuerunnerstatus_json";
        metrics_path = "/probe";
        params.module = [ "default" ];
        static_configs = [
          {
            targets = [ "${config.services.hydra.hydraURL}/queue-runner-status" ];
          }
        ];
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "localhost:${toString config.services.prometheus.exporters.json.port}";
          }
        ];
      }
      {
        job_name = "rtl_433";
        static_configs = [
          {
            targets = [ "aqua:8433" ];
          }
        ];
      }
    ];
  };
}
