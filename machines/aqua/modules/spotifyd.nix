{ lib, pkgs, ... }:

let
  # Note(Mindavi): ensure this port is opened in firewall, too.
  spotifyd_zeroconf_port = 7452;
in
{
  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd;
    settings = {
      global = {
        # TODO(Mindavi): lossless?
        bitrate = 320;
        device_name = "kantoor (aqua)";
        # Audio/video receiver
        device_type = "a_v_r";

        use_mpris = false;
        use_keyring = false;

        # Note(Mindavi): ensure this port is opened in firewall, too.
        zeroconf_port = spotifyd_zeroconf_port;
        # Make sure zeroconf discovery is enabled.
        disable_discovery = false;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ spotifyd_zeroconf_port ];
}
