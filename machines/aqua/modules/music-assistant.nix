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
      "radiobrowser"
      "slimproto"
      "soundcloud"
      "spotify"
    ];
  };
}
