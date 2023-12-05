{ pkgs, config, ... }:
{
  services.mosquitto = {
    enable = true;
    persistence = false;
    logType = [ "all" ];
    listeners = [
      {
        address = "127.0.0.1";
        settings = {
          allow_anonymous = true;
        };
        port = 1883;
        # TODO(Mindavi): unsafe, but ok-ish if only allowed from localhost
        omitPasswordAuth = true;
        users = {
          rtl_433 = {
            acl = [
              "topic read rtl_433"
              "topic write rtl_433/aqua/#"
            ];
          };
          monitor = {
            acl = [
              "topic read #"
            ];
          };
        };
        acl = [
          "topic read public/#"
        ];
      }
    ];
  };
}

