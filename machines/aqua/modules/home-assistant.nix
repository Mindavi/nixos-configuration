{ pkgs, config, ...}:
{
  # HACK(Mindavi): to be removed ASAP
  nixpkgs.config.permittedInsecurePackages = [
   "openssl-1.1.1w"
  ];

  services.home-assistant = {
    config = {
      homeassistant = {
        name = "Home";
        temperature_unit = "C";
        country = "NL";
        unit_system = "metric";
        time_zone = "Europe/Amsterdam";
      };
      http = {
        server_port = 8123;
        #server_host = "127.0.0.1";
        #use_x_forwarded_for = true;
        #trusted_proxies = [ "127.0.0.1" ];
        ip_ban_enabled = true;
        login_attempts_threshold = 4;
      };
      logger = {
        default = "info";
      };
      lovelace.mode = "yaml";

      config = {};
      #default_config = {};
      energy = {};
      frontend = {};
      history = {};
      input_boolean = {};
      mobile_app = {};
      system_health = {};
    };
    lovelaceConfig = {
      title = "An example.";
      views = [
        {
          title = "First page.";
          cards = [
            {
              type = "markdown";
              title = "Lovelace";
              content = "Hello, lovelace **world**, it _works_.";
            }
          ];
        }
      ];
    };
    package = pkgs.home-assistant.override {
      extraComponents = [
        "default_config"
        "energy"
        "esphome"
        "history"
        "html5"
        "http"
        "local_ip" # ???
        "logbook"
        "lovelace"
        "met"
        #"minecraft_server"
        "mqtt"
        "shelly"
      ];
    };
    # TODO(Mindavi): Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
}

