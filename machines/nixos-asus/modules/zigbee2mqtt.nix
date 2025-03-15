{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = false;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      homeassistant = true; # enable autodiscovery even though we won't run home assistant on nixos-asus
      permit_join = false;
      serial = {
        # TODO(Mindavi): mDNS does not work at all, figure out why this is. Maybe systemd service restrictions from NixOS?
        #port = "mdns://slzb-06";
        port = "tcp://192.168.178.23:6638";
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
  systemd.services.zigbee2mqtt.serviceConfig = {
    # zigbee2mqtt stops when the adapter disconnects from the network / the laptop disconnects from the network
    # it happily exits with exit code 0, so let's just always try to restart here
    Restart = lib.mkForce "always";
  };
}
