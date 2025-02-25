{ config, ... }:
let
  mqtt_server_name = config.networking.hostName;
in
{
  services.home-assistant = {
    config = {
      # Broker must be set up via the web UI.
      mqtt = {
        sensor = [
        ];
      };
    };
  };
}
