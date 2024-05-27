{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    logType = [ "all" ];
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
          };
        };
        acl = [
          "topic read public/#"
          "pattern write public/%u/#"
        ];
      }
      {
        address = "0.0.0.0";
        port = 1883;
        settings = {
          allow_anonymous = true;
        };
        users = {
          test_user = {
            acl = [
              "read rtl_433/#"
            ];
            password = "test_user_mqtt";
          };
          monitor = {
            acl = [
              "read #"
            ];
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
        };
        acl = [
          "topic read public/#"
          "pattern write public/%u/#"
        ];
      }
    ];
  };
}

