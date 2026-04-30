{ lib, pkgs, ... }:

let
  # Note(Mindavi): ensure this port is opened in firewall, too.
  spotifyd_zeroconf_port = 7452;
in
{
  services.spotifyd = {
    enable = false;
    package = pkgs.spotifyd;
    settings = {
      global = {
        # TODO(Mindavi): lossless?
        bitrate = 320;
        device_name = "kantoor (aqua)";
        # Audio/video receiver
        device_type = "a_v_r";
        # pipewire emulates pulseaudio
        backend = "pulseaudio";
        cache_path = "/var/cache/spotifyd";

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

  systemd.services.spotifyd = {
    serviceConfig = {
      # Inspired by squeezelite:
      #   https://github.com/NixOS/nixpkgs/blob/d66f00f7ea162a626f9274978cc135cd3c067598/nixos/modules/services/audio/squeezelite.nix#L64
      SupplementaryGroups = [
        "audio"
        "pipewire"
      ];
      RuntimeDirectory = "squeezelite";
      RuntimeDirectoryMode = "0700";
      StateDirectory = "squeezelite";
      StateDirectoryMode = "0700";
    };
    environment = {
      XDG_CONFIG_HOME = "%S/squeezelite/.config";
      XDG_RUNTIME_DIR = "%t/squeezelite";
    };
  };
}
