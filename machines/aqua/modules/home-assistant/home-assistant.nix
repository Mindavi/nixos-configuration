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

      config = { };
      #default_config = {};
      energy = { };
      frontend = { };
      history = { };
      input_boolean = { };
      input_number = { };
      logbook = { };
      mobile_app = { };
      network = { };
      prometheus = {
        namespace = "home";
        requires_auth = true;
      };
      recorder = {
        # TODO(Mindavi): Check database size now and then.
        auto_purge = true;
      };
      sun = { };
      system_health = { };
      system_log = { };

      "automation manual" = [ ];
      "automation ui" = "!include automations.yaml";
    };
    extraComponents = [
      # TODO(Mindavi): fix bluetooth permissions:
      # aqua hass[PID]: INFO (MainThread) [bluetooth_auto_recovery.recover] hci1 permission denied to /dev/bus/usb/001/007 while attempting USB reset: [Errno 13] Permission denied: '/dev/bus/usb/001/007'

      "bluetooth"
      "cast"
      "climate"
      "conversation"
      "daikin"
      "default_config"
      "dhcp"
      "dsmr"
      "energy"
      "enphase_envoy"
      "esphome"
      "fritz"
      "gardena_bluetooth"
      "govee_ble"
      "history"
      "html5"
      "http"
      "husqvarna_automower_ble"
      "ibeacon"
      "isal" # https://github.com/NixOS/nixpkgs/issues/330377
      "linkplay"
      "local_ip" # ???
      "logbook"
      "lovelace"
      "luci"
      "met"
      "mobile_app"
      "mqtt"
      "music_assistant"
      "owntracks"
      "ping"
      "piper"
      "prometheus"
      "renault"
      "shelly"
      "shopping_list"
      "smlight"
      "snmp"
      "ssdp"
      "switchbot"
      "ubus"
      "webostv"
      "whisper"
      "wyoming"
      "xiaomi_ble"
      "zha"
    ];
    package = pkgs.home-assistant;
    openFirewall = false;
    enable = true;
    configDir = "/var/lib/hass";
  };
  # Ensure automations.yaml is generated if it doesn't exist yet.
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
  ];

  # Allow USB adapter to be controlled by home assistant.
  # Should fix permission issues with controlling the adapter.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2357", ATTRS{idProduct}=="0604", GROUP="hass", MODE="0660"
  '';
}
