{ config, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Headless support
  # https://wiki.nixos.org/wiki/PipeWire
  # Socket activation too slow for headless; start at boot instead.
  services.pipewire.socketActivation = false;
  # Start WirePlumber (with PipeWire) at boot.
  systemd.user.services.wireplumber.wantedBy = [ "default.target" ];
  users.users.rick.linger = true; # keep user services running
}
