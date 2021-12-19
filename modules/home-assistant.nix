{ pkgs, config, ...}:
{
  services.home-assistant = {
    port = 8123;
    # Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

