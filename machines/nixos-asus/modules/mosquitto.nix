{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    # TODO(Mindavi): probably should reduce this at some point, but at least debug is disabled now.
    logType = [
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
          };
          monitor = {
            acl = [
              "read #"
            ];
            password = "everythingisvisibleforme";
          };
        };
      }
    ];
  };
}
