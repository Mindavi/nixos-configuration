{
  ...
}:

let
  aqua_url = "home.arpa";
  nixos-asus_url = "[fd37:191a:d082:0555::2]";
in
{
  services.glance = {
    enable = true;
    openFirewall = false;
    settings = {
      server = {
        port = 8082;
        host = "127.0.0.1";
        base-url = "/dashboard";
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "aqua";
                      links = [
                        {
                          title = "Grafana";
                          url = "http://grafana.${aqua_url}/grafana";
                        }
                        {
                          title = "Home assistant";
                          url = "http://hass.${aqua_url}";
                        }
                        # {
                        #   title = "Hydra";
                        #   url = "http://hydra.${aqua_url}/hydra";
                        # }
                        {
                          title = "Music assistant";
                          url = "http://music-assistant.${aqua_url}";
                        }
                        {
                          title = "Photos";
                          url = "http://photos.${aqua_url}";
                        }
                        {
                          title = "Prometheus";
                          url = "http://prometheus.${aqua_url}/prometheus";
                        }
                        {
                          title = "Syncthing";
                          url = "http://syncthing.${aqua_url}/syncthing/";
                        }
                        {
                          title = "Zigbee2MQTT";
                          url = "http://zigbee2mqtt.${aqua_url}/zigbee2mqtt";
                        }
                      ];
                    }
                    {
                      title = "nixos-asus";
                      links = [
                        {
                          title = "Syncthing";
                          url = "http://${nixos-asus_url}:8384";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
