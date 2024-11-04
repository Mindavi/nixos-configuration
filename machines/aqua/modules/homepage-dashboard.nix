{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    # TODO(mindavi): Disable again
    openFirewall = true;
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
                href = "http://aqua.local";
              }
            ];
          }
          {
            "Hydra" = [
              {
                abbr = "HY";
                href = "http://aqua.local/hydra";
              }
            ];
          }
          {
            "Traefik" = [
              {
                abbr = "TR";
                href = "http://traefik.aqua/dashboard/";
              }
            ];
          }
        ];
      }
      {
        Laptop = [
          {
            Syncthing = [
              {
                abbr = "ST";
                href = "http://localhost:8384";
              }
            ];
          }
          {
            Prometheus = [
              {
                abbr = "PROM";
                href = "http://localhost:9090";
              }
            ];
          }
        ];
      }
    ];
  };
}
