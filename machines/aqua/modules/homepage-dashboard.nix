{
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
                description = "Home automation dashboard";
              }
            ];
          }
          {
            "Hydra" = [
              {
                abbr = "HY";
                href = "http://aqua.local/hydra";
                description = "Continuous integration for Nix";
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
            Syncthing = [
              {
                abbr = "ST";
                href = "http://localhost:8384";
                description = "Synchronize files between devices";
              }
            ];
          }
          {
            Prometheus = [
              {
                abbr = "PROM";
                href = "http://localhost:9090";
                description = "Time series database";
              }
            ];
          }
        ];
      }
    ];
  };
}
