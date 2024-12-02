{
  ...
}:

let
  aqua_url = "172.16.1.8";
  nixos-asus_url = "172.16.1.2";
in
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    openFirewall = false;
    settings = {
      startUrl = "/dashboard";
    };

    bookmarks = [
      {
        General = [
          {
            "Home Assistant" = [
              {
                abbr = "HASS";
                href = "http://${aqua_url}";
                description = "Home automation dashboard";
              }
            ];
          }
          {
            "Hydra" = [
              {
                abbr = "HY";
                href = "http://${aqua_url}/hydra";
                description = "Continuous integration for Nix";
              }
            ];
          }
          {
            "Prometheus" = [
              {
                abbr = "PROM";
                href = "http://${nixos-asus_url}/prometheus";
                description = "Time series database";
              }
            ];
          }
          {
            "Grafana" = [
              {
                abbr = "GRAF";
                href = "http://${nixos-asus_url}/grafana";
                description = "Query and visualise time series data";
              }
            ];
          }
          {
            "Traefik" = [
              {
                abbr = "TR";
                href = "http://traefik.aqua/dashboard/";
                description = "Reverse proxy";
              }
            ];
          }
        ];
      }
      {
        Laptop = [
          {
            "Syncthing" = [
              {
                abbr = "ST";
                href = "http://${nixos-asus_url}:8384";
                description = "Synchronize files between devices";
              }
            ];
          }
          {
            "Prometheus" = [
              {
                abbr = "PROM";
                href = "http://${nixos-asus_url}:9090";
                description = "Time series database";
              }
            ];
          }
        ];
      }
    ];
  };
}
