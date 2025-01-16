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
        # localhost has a different port and only allows connections from the same machine.
        address = "127.0.0.1";
        port = 1884;
        users = {
          rtl_433 = {
            acl = [
              "read rtl_433/#"
              "write rtl_433/aqua/#"
            ];
            password = "rtl_433_pass";
          };
          monitor = {
            acl = [
              "read #"
            ];
            password = "everythingisvisibleforme";
          };
          inverter = {
            acl = [
              "write sensor/inverter/ginlong-inverter-monitor/#"
            ];
            password = "inverter-monitor<>";
          };
        };
        acl = [
          "topic read public/#"
          "pattern write public/%u/#"
          "pattern write public/%c/#"
        ];
      }
      {
        address = "0.0.0.0";
        port = 1883;
        settings = {
          allow_anonymous = true;
        };
        users = {
          monitor = {
            acl = [
              "read #"
            ];
            password = "everythingisvisibleforme";
          };
          sensor = {
            acl = [
              "write sensor/+/+/control"
              "write sensor/+/+/debug"
              "write sensor/+/+/status"
              "write sensor/+/+/will"
            ];
            password = "ThisiswhatIfeelitslike...";
          };
          open_mqtt_gateway = {
            acl = [
              # Home assistant autodiscovery.
              "write homeassistant/#"
              "readwrite openmqttgateway/#"
            ];
            password = "open_mqtt_gateway_1234";
          };
        };
        acl = [
          "topic read public/#"
          "pattern write public/%c/#"
          "pattern write public/%u/#"
        ];
      }
    ];
  };
}
