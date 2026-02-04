{
  lib,
  config,
  ...
}:

{
  # Enable the X11 windowing system.
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    # Enable touchpad support.
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
      };
    };
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };
}
