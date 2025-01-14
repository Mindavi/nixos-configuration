{
  lib,
  config,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = false;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = false;
      serial = {
        port = "mdns://slzb-06";
        adapter = "zstack";
      };
      frontend = {
        enabled = true;
        # TODO(Mindavi): port?
        # port = 1234;
        # base_url = "/zigbee2mqtt";
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        client_id = "zigbee2mqtt_1";
      };
    };
  };
}
