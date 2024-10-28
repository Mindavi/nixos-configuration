{ pkgs, config, ... }:
{
  # Used for CoIoT on Shelly plugs
  # FIXME(Mindavi): move to firewall.nix and only allow packets from local network.
  networking.firewall.allowedUDPPorts = [ 5683 ];
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
        use_x_forwarded_for = true;
        trusted_proxies = [
            # Traefik
            "127.0.0.1"
            # Local LAN
            "192.168.1.0/24"
            # Wireguard
            "172.16.1.0/24"
            "fe80::/64"
        ];
        ip_ban_enabled = true;
        login_attempts_threshold = 4;
      };
      logger = {
        default = "info";
      };
      lovelace.mode = "yaml";

      config = { };
      #default_config = {};
      energy = { };
      frontend = { };
      history = { };
      input_boolean = { };
      input_number = { };
      mobile_app = { };
      network = { };
      recorder = {
        # TODO(Mindavi): Check database size now and then.
        auto_purge = false;
      };
      sun = { };
      system_health = { };
      system_log = { };

      "automation manual" = [
        {
          alias = "Wake up Lights";
          trigger = {
            platform = "time";
            at = "sensor.pixel_7_next_alarm";
          };
          condition = {
            condition = "state";
            entity_id = "device_tracker.pixel_7";
            state = "home";
          };
          action = {
            service = "light.turn_on";
            target = {
              entity_id = "light.lamp_slaapkamer_rick";
            };
            data = {
              transition = 60; # 60 seconds
              brightness_pct = 100;
            };
          };
          mode = "single";
        }
        {
          alias = "Backup Home Assistant every night at 3 AM";
          trigger = {
            platform = "time";
            at = "03:00:00";
          };
          action = {
            service = "backup.create";
          };
        }
      ];
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
      "isal" # https://github.com/NixOS/nixpkgs/issues/330377
      "local_ip" # ???
      "logbook"
      "lovelace"
      "met"
      #"minecraft_server"
      "mobile_app"
      "mqtt"
      "renault"
      "shelly"
      "ssdp"
      "zha"
    ];
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
