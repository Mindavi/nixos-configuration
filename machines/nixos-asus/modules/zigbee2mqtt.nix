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
        port = "tcp://192.168.1.74:6638";
        # adapter = "zstack";  # not needed when using mDNS autodiscovery
      };
      frontend = {
        enabled = true;
        port = 8080;
      };
      mqtt = {
        server = "mqtt://localhost:8123";
        client_id = "zigbee2mqtt_1";
        user = "zigbee2mqtt";
        password = "zb2mqttpass_test";
        base_topic = "zigbee2mqtt";
      };
      advanced = {
        log_level = "debug";
        log_output = [
          "console"
        ];
      };
    };
  };
}
