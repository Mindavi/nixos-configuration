{ config, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    systemWide = true;
    wireplumber.extraConfig = {
      "fiio-sample-rate" = {
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "alsa_output.usb-FiiO_FiiO_BTR3K_ABCDEF0123456789-00.analog-stereo";
              }
            ];
            actions = {
              update-props = {
                # TODO(Mindavi): do we need to update something here to make it work?
              };
            };
          }
        ];
      };
    };
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            192000
            48000
            44100
          ];
        };
      };

    };
  };
}
