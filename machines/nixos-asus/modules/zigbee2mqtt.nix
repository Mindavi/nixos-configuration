{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = true;
    # TODO(Mindavi): wait for https://github.com/NixOS/nixpkgs/pull/371053 to propagate to nixos-unstable
    package = pkgs.zigbee2mqtt; #_2;
    settings = {
      homeassistant = true;  # enable autodiscovery even though we won't run home assistant on nixos-asus
      permit_join = false;
      serial = {
        port = "tcp://192.168.1.74:6638";
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
