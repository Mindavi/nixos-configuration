{ pkgs, config, ...}:
{
  services.home-assistant = {
    config = {
      http.server_port = 8123;
    };
    package = pkgs.home-assistant.override {
      extraComponents = [
        "default_config"
        "discovery"
        "history"
        "html5"
        "http"
        "local_ip" # ???
        "logbook"
        "lovelace"
        #"minecraft_server"
        "mqtt"
        "shelly"
      ];
    };
    # Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

