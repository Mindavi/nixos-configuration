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

    bookmarks = [
      {
        Developer = [
          {
            Github = [
              {
                abbr = "GH";
                href = "https://github.com/";
              }
            ];
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = [
              {
                abbr = "YT";
                href = "https://youtube.com/";
              }
            ];
          }
        ];
      }
    ];
  };
}
