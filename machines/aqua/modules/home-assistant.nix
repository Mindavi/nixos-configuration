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
        #external_url = "TBD";
      };
      #auth_providers = {}; # kept disabled for now, as recommended on the home-assistant page
      #                     # something to consider later for easier onboarding of others in the house
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
      #map = {}; # deprecated in yaml, to be removed in 2024.10
      mobile_app = {};
      network = {};
      sun = {};
      system_health = {};
      system_log = {};

      "automation manual" = [];
      "automation ui" = "!include automations.yaml";
    };
    extraComponents = [
      "default_config"
      "dhcp"
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
      "mobile_app"
      "mqtt"
      "shelly"
      "ssdp"
      "zha"
    ];
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
    package = pkgs.home-assistant;
    # TODO(Mindavi): Use a proxy.
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
  # Ensure automations.yaml is generated if it doesn't exist yet.
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
  ];
}

