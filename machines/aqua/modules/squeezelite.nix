{
  config,
  lib,
  ...
}:

{
  # Enable this to be able to play music on the server AUX output.
  services.squeezelite = {
    # Fails on startup with the following logs:
    # Mar 06 22:07:13 aqua squeezelite[8447]: [22:07:13.352240] test_open:281 playback open error: Host is down
    # Mar 06 22:07:13 aqua squeezelite[8447]: [22:07:13.352292] output_init_common:401 unable to open output device: pipewire
    # https://blog.masoko.net/linux/sqeezelite-wont-mix-with-user-audio/
    # ExtraArguments for now doesn't seem to make any differences.
    # Possibly permissions issue?
    enable = false;
    # TODO(Mindavi): get this also working with the Fiio BTR3K DAC.
    extraArguments = "-o default";
    pulseAudio = true;
  };
}
