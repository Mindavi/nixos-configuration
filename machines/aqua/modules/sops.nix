{ config, ... }:

{
  sops.defaultSopsFile = ../../../secrets/aqua.yaml;
  sops.secrets = {
    "mosquitto/monitor" = {
      owner = config.systemd.services.mosquitto.serviceConfig.User;
      group = config.systemd.services.mosquitto.serviceConfig.Group;
    };
    "samba/familie" = {};
    "samba/gedeeld" = {};
    "samba/rick" = {};
  };
}
