{ pkgs, config, ...}:
{
  services.home-assistant = {
    port = 8123;
    package = pkgs.home-assistant.override {
      extraPackages = ps: with ps; [ ifaddr ];
    };
    # Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

