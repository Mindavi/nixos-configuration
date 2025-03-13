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
          zigbee2mqtt = {
            password = ")O(*'e5[2#OpUch9,z7gn5z.";
            acl = [
              "readwrite zigbee2mqtt/#"
              "write homeassistant/#"
            ];
          };
          home_assistant = {
            acl = [
              "readwrite #"
            ];
            hashedPassword = "$7$101$bHbx1V4Ad0fq2RNP$zaV4lS/YnXR3Fe6qdeh6DxllW6pkeytDv+8WlLnLK1cXZ6m5oqNXcLiUUsqfFY567AsjqNg6ncRvs34zedNmVQ==";
          };
        };
        acl = [
          "topic read public/#"
          "pattern write public/%u/#"
          "pattern write public/%c/#"
        ];
      }
      {
        # Available on all interfaces
        address = null;
        port = 1883;
        # settings = {
        #   allow_anonymous = true;
        # };
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
              # Prefix as configured in the gateway.
              "readwrite home/#"
            ];
            hashedPassword = "$7$101$0O71NK+NPfshX2EX$3Q62cfnr+3ytTKiN449UU9mtrExTJ6cjDRU5bLLRIrQAxSN9eJ+pZj7rjT0ViWLcutoueaPJvvKptKfZ5AW5tQ==";
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
