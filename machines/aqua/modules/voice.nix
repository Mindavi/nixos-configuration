{
  pkgs,
  config,
  ...
}:

{
  services.wyoming = {
    piper.servers.hass = {
      enable = true;
      # https://rhasspy.github.io/piper-samples/#nl_NL-mls-medium
      voice = "nl_NL-mls-medium";
      useCUDA = false;
      uri = "tcp://127.0.0.1:10200";
      speaker = 7432;
    };
    faster-whisper = {
      servers.hass = {
        enable = true;
        model = "medium"; # other options: base-int8, small
        language = "nl";
        uri = "tcp://127.0.0.1:10300";
        device = "cpu";
      };
    };
    openwakeword = {
      enable = true;
      uri = "tcp://127.0.0.1:10400";
    };
    # TODO(Mindavi): consider installing satellite at some point too.
  };
}
