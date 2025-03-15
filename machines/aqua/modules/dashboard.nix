{
  ...
}:

let
  aqua_url = "172.16.1.8";
  nixos-asus_url = "172.16.1.2";
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
                          title = "Home assistant";
                          url = "http://${aqua_url}";
                        }
                        {
                          title = "Hydra";
                          url = "http://${aqua_url}/hydra";
                        }
                        {
                          title = "Prometheus";
                          url = "http://${aqua_url}/prometheus";
                        }
                        {
                          title = "Grafana";
                          url = "http://${aqua_url}/grafana";
                        }
                        {
                          title = "Traefik";
                          url = "http://${aqua_url}/traefik/";
                        }
                        {
                          title = "Zigbee2MQTT";
                          url = "http://${aqua_url}/zigbee2mqtt";
                        }
                      ];
                    }
                    {
                      title = "nixos-asus";
                      links = [
                        {
                          title = "Prometheus";
                          url = "http://${nixos-asus_url}:9090";
                        }
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
