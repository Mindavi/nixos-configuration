{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    logType = [ "all" ];
    listeners = [
      {
        address = "127.0.0.1";
        port = 1883;
        # TODO(Mindavi): unsafe, but ok-ish if only allowed from localhost
        omitPasswordAuth = true;
        acl = [
          "topic read public/#"

          "user monitor"
          "topic read #"

          "user rtl"
          "topic write rtl_433/aqua/#"
        ];
      }
    ];
  };
}

