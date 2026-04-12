{
  config,
  lib,
  ...
}:

{
  # Enable this to be able to play music on the server AUX output.
  services.squeezelite = {
    enable = true;
    extraArgs = "-o default";
    pulseaudio.enable = true;
    name = "Kantoor-aqua";
  };
}
