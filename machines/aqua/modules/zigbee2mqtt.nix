{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      homeassistant.enabled = config.services.home-assistant.enable;
      permit_join = false;
      serial = {
        port = "mdns://slzb-06";
        #port = "tcp://192.168.1.23:6638";
        adapter = "zstack";
      };
      frontend = {
        enabled = true;
        port = 8081;
        base_url = "/zigbee2mqtt";
      };
      mqtt = {
        server = "mqtt://localhost:1884";
        client_id = "zigbee2mqtt_1";
        user = "zigbee2mqtt";
        password = ")O(*'e5[2#OpUch9,z7gn5z.";
        base_topic = "zigbee2mqtt";
      };
      availability = {
        enabled = true;
      };
      advanced = {
        log_level = "info";
        log_namespaced_levels = {
          "z2m:mqtt" = "warning";
        };
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
    RestartSec = 15;
    RestartSteps = 10;
    RestartMaxDelaySec = "5min";
  };
}
