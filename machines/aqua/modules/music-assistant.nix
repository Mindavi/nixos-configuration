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
  systemd.services.music-assistant.serviceConfig = {
    # For some reason, music-assistant fails on first startup.
    # To be done is figure out what the reason is and fix it better, but for now just allow a few restarts.
    Restart = "on-failure";
    RestartSec = 120;
    RestartSteps = 5;
    RestartMaxDelaySec = "15min";
    RestartMode = "debug";
  };
}
