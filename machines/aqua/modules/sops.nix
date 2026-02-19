{ config, ... }:

{
  sops.defaultSopsFile = ../../../secrets/aqua.yaml;
  sops.secrets = {
    "grafana/secret_key" = {
      owner = config.systemd.services.grafana.serviceConfig.User;
    };
    "mosquitto/monitor" = {
      owner = config.systemd.services.mosquitto.serviceConfig.User;
      group = config.systemd.services.mosquitto.serviceConfig.Group;
    };
    "samba/gedeeld" = { };
    "samba/rick" = { };
    "prometheus/homeassistant" = {
      owner = config.systemd.services.prometheus.serviceConfig.User;
    };
  };
}
