{ pkgs, config, ... }:
{
  services.music-assistant = {
    enable = true;
    providers = [
      "builtin"
      "chromecast"
      "dlna"
      "filesystem_local"
      "jellyfin"
      "podcastfeed"
      "radiobrowser"
      "soundcloud"
      "spotify"
      "spotify_connect"
      "squeezelite"
    ];
  };
}
