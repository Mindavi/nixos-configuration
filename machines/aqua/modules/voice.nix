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
        # see https://github.com/rhasspy/rhasspy3/blob/master/programs/asr/faster-whisper/script/download.py
        model = "base-int8";
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
