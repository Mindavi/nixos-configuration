{
  lib,
  config,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;  # enable autodiscovery even though we won't run home assistant on nixos-asus
      permit_join = false;
      serial = {
        port = "mdns://SLZB-06";
        adapter = "zstack";
      };
      frontend = {
        enabled = true;
        port = 8080;
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        client_id = "zigbee2mqtt_1";
        user = "zigbee2mqtt";
        password = "zb2mqttpass_test";
        base_topic = "zigbee2mqtt";
      };
      advanced = {
        log_level = "info";
        log_output = [
          "console"
        ];
      };
    };
  };
}
