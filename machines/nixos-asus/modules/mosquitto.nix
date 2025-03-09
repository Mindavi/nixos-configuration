{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    logType = [
      "debug"
      "error"
      "warning"
      "notice"
      "information"
      "subscribe"
      "unsubscribe"
    ];
    listeners = [
      {
        # localhost only allows connections from the same machine.
        address = "127.0.0.1";
        port = 1883;
        settings = {
          allow_anonymous = true;
        };
        # !!! WARNING: only for services running on the same machine.
        users = {
          zigbee2mqtt = {
            password = "zb2mqttpass_test";
            acl = [
              "read #"
              "write #"
            ];
          };
          monitor = {
            acl = [
              "read #"
            ];
            password = "everythingisvisibleforme";
          };
          hass = {
            acl = [
              "read #"
              "write #"
            ];
            password = "home-assistant-1";
          };
        };
        acl = [
          "topic readwrite #"
        ];
      }
      {
        # Available on all interfaces
        address = null;
        port = 1884;
        users = {
          open_mqtt_gateway = {
            acl = [
              "write #"
            ];
            hashedPassword = "$7$101$0O71NK+NPfshX2EX$3Q62cfnr+3ytTKiN449UU9mtrExTJ6cjDRU5bLLRIrQAxSN9eJ+pZj7rjT0ViWLcutoueaPJvvKptKfZ5AW5tQ==";
          };
        };
      }
    ];
  };
}
