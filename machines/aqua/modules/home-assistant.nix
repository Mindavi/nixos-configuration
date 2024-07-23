{ pkgs, config, ...}:
let
  mqtt_server_name = config.networking.hostName;
in {
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
      # Broker must be set up via the web UI.
      mqtt = {
        sensor = [
          {
            name = "Temperature bedroom Rick";
            object_id = "temperature_bedroom_rick";
            state_topic = "sensor/temperature/bedroom/status";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Temperature bedroom Rick 2";
            object_id = "temperature_bedroom_rick_2";
            state_topic = "sensor/temperature/bedroom/debug";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Humidity bedroom Rick";
            object_id = "humidity_bedroom_rick";
            state_topic = "sensor/humidity/bedroom/status";
            unit_of_measurement = "%";
            device_class = "humidity";
            state_class = "measurement";
            expire_after = 300;
          }
          {
            name = "Temperature living room (ch1)";
            object_id = "temperature_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature washing room (ch2)";
            object_id = "temperature_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature pantry (ch3)";
            object_id = "temperature_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/+/temperature_C";
            unit_of_measurement = "°C";
            device_class = "temperature";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity living room (ch1)";
            object_id = "humidity_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity washing room (ch2)";
            object_id = "humidity_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Humidity pantry (ch3)";
            object_id = "humidity_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/+/humidity";
            unit_of_measurement = "%";
            device_class = "humidity";
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Battery status living room (ch1)";
            object_id = "battery_status_bresser_portable_1";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/1/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status washing room (ch2)";
            object_id = "battery_status_bresser_portable_2";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/2/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Battery status pantry (ch3)";
            object_id = "battery_status_bresser_portable_3";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Nexus-TH/3/+/battery_ok";
            state_class = "measurement";
          }
          {
            name = "Temperature outside";
            object_id = "temperature_outside";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Hideki-Temperature/3/+/temperature_C";
            unit_of_measurement = "°C";
            value_template = "{{ value | round(1) }}";
            device_class = "temperature";
            force_update = true;
            expire_after = 1800;
            state_class = "measurement";
          }
          {
            name = "Temperature outside battery status";
            object_id = "temperature_outside_battery_status";
            state_topic = "rtl_433/${mqtt_server_name}/devices/Hideki-Temperature/3/+/battery_ok";
            state_class = "measurement";
          }
        ];
      };
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
      title = "Thuis";
      views = [
        {
          title = "Overzicht";
          cards = [
            {
              type = "entities";
              title = "Temperaturen";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.temperature_bedroom_rick";
                  name = "Slaapkamer Rick 1";
                }
              ];
            }
            {
              type = "entities";
              title = "Luchtvochtigheid";
              show_header_toggle = false;
              entities = [
                {
                  entity = "sensor.humidity_bedroom_rick";
                  name = "Slaapkamer Rick";
                }
              ];
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

