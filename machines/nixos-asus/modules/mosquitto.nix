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
          openmqttgateway = {
           acl = [
              "write #"
            ];
            password = "MyPasswordForOpenMqttGateway";
          };
        };
        acl = [
          "topic readwrite #"
        ];
      }
    ];
  };
}
