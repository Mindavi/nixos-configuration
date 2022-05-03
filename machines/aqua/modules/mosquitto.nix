{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    listeners = {
      default = {
        port = 1883;
        acl = [
          "topic read public/#"

          "user monitor"
          "topic read #"

          "user phone"
          "topic read #"
          "topic write sensor/+/+/control"

          "user devicelist"
          
        ];
      };
    ];
  };
}

