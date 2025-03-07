{ pkgs, config, ... }:
{
  # Used for CoIoT on Shelly plugs
  # FIXME(Mindavi): move to firewall.nix and only allow packets from local network.
  networking.firewall.allowedUDPPorts = [ 5683 ];
  networking.firewall.allowedTCPPorts = [ 8123 ];
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
          # Traefik / loopback
          "127.0.0.1"
          "::1"
          # Local LAN
          "192.168.1.0/24"
          "fe80::/64"
          # Wireguard
          "172.16.1.0/24"
        ];
        # TODO(Mindavi): I got locked out due to this, and I don't know why...
        # Disable it until I figure out what happened.
        ip_ban_enabled = false;
        login_attempts_threshold = 4;
      };
      logger = {
        default = "info";
      };
      lovelace.mode = "storage";

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
        auto_purge = true;
      };
      sun = { };
      system_health = { };
      system_log = { };

      "automation manual" = [
      ];
      "automation ui" = "!include automations.yaml";
    };
    extraComponents = [
      "default_config"
      "dhcp"
      "dsmr"
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
