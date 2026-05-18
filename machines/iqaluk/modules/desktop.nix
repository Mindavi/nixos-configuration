{
  lib,
  config,
  ...
}:

{
  # Enable the X11 windowing system.
  services = {
    displayManager.plasma-login-manager.enable = true;
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
