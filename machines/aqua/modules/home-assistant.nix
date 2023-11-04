{ pkgs, config, ...}:
{
  services.home-assistant = {
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "UTC";
      };
      http = {
        server_port = 8123;
        server_host = "127.0.0.1";
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
        ip_ban_enabled = true;
        login_attempts_threshold = 4;
      };
      frontend = {};
    };
    package = pkgs.home-assistant.override {
      extraComponents = [
        "default_config"
        #"history"
        #"html5"
        #"http"
        #"local_ip" # ???
        #"logbook"
        #"lovelace"
        #"minecraft_server"
        "mqtt"
        #"shelly"
      ];
    };
    # Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

