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
        port = "8082";
        host = "127.0.0.1";
      };
      pages = [
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
                  url = "http://${nixos-asus_url}/prometheus";
                }
                {
                  title = "Grafana";
                  url = "http://${nixos-asus_url}/grafana";
                }
                {
                  title = "Traefik";
                  url = "http://traefik.aqua/dashboard/";
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
                {
                  title = "Prometheus";
                  url = "http://${nixos-asus_url}:9090";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
