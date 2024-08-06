{ lib, pkgs, config, ... }:
let
  ginlong-monitor = (pkgs.callPackage ./pkgs/ginlong-monitor {});
in
{
  environment.systemPackages = with pkgs; [
    ginlong-monitor
  ];
  networking.firewall.allowedTCPPorts = [ 9999 ];
  systemd.services.solar-inverter = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" "mosquitto.service" ];
    after = [ "network-online.target" "mosquitto.service" ];
    description = "solar inverter listener daemon";
    environment = {
      MQTT_CLIENTID = "ginlong-inverter-monitor";
      MQTT_INVERTER_TOPIC = "sensor/inverter/ginlong-inverter-monitor/status";
      MQTT_PASSWORD = "inverter-monitor<>";
      MQTT_SERVERPORT = "1884";
      MQTT_SERVERADDRESS = "127.0.0.1";
      MQTT_USERNAME = "inverter";
    };
    serviceConfig = {
      Type = "exec";
      ExecStart = "${ginlong-monitor}/bin/ginlongmqtt";
      DynamicUser = "yes";
      Restart = "on-failure";
      # No rush, a packet comes every 6 mins or so.
      RestartSec = "30s";
      ProtectSystem = "strict";
      ProtectHome = true;
      # TODO(Mindavi): Maybe for now write to the actual /tmp instead of some private directory?
      #PrivateTmp = true;
      WorkingDirectory = "/tmp";
    };
  };
}
