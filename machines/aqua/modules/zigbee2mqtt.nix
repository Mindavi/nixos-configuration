{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      homeassistant.enabled = config.services.home-assistant.enable;
      permit_join = false;
      serial = {
        # TODO(Mindavi): mDNS does not work at all, figure out why this is. Maybe systemd service restrictions from NixOS?
        # Starting Zigbee2MQTT without watchdog.
        # Migration notes written in /var/lib/zigbee2mqtt/migration-1-to-2.log
        # Migration notes written in /var/lib/zigbee2mqtt/migration-2-to-3.log
        # Migration notes written in /var/lib/zigbee2mqtt/migration-3-to-4.log
        # [2025-11-24 19:49:42] info:         z2m: Logging to console
        # [2025-11-24 19:49:42] info:         z2m: Starting Zigbee2MQTT version 2.6.3 (commit #unknown)
        # [2025-11-24 19:49:42] info:         z2m: Starting zigbee-herdsman (6.3.2)
        # [2025-11-24 19:49:42] info:         zh:adapter:discovery: Starting mdns discovery for coordinator: slzb-06
        # SystemError: A system error occurred: uv_interface_addresses returned Unknown system error 97 (Unknown system error 97)
        #     at Object.networkInterfaces (node:os:217:16)
        #     at allInterfaces (/nix/store/hka500f7g0nk33n8c9gmbld2ih6h754j-zigbee2mqtt-2.6.3/lib/node_modules/zigbee2mqtt/node_modules/.pnpm/multicast-dns@7.2.5/node_modules/multicast-dns/index.js:184:21)
        #     at EventEmitter.that.update (/nix/store/hka500f7g0nk33n8c9gmbld2ih6h754j-zigbee2mqtt-2.6.3/lib/node_modules/zigbee2mqtt/node_modules/.pnpm/multicast-dns@7.2.5/node_modules/multicast-dns/index.js:134:63)
        #     at Socket.<anonymous> (/nix/store/hka500f7g0nk33n8c9gmbld2ih6h754j-zigbee2mqtt-2.6.3/lib/node_modules/zigbee2mqtt/node_modules/.pnpm/multicast-dns@7.2.5/node_modules/multicast-dns/index.js:55:12)
        #     at Socket.emit (node:events:531:35)
        #     at startListening (node:dgram:209:10)
        #     at node:dgram:404:7
        #     at processTicksAndRejections (node:internal/process/task_queues:91:21)

        port = "mdns://slzb-06";
        #port = "tcp://192.168.1.23:6638";
        adapter = "zstack";
      };
      frontend = {
        enabled = true;
        port = 8081;
        base_url = "/zigbee2mqtt";
      };
      mqtt = {
        server = "mqtt://localhost:1884";
        client_id = "zigbee2mqtt_1";
        user = "zigbee2mqtt";
        password = ")O(*'e5[2#OpUch9,z7gn5z.";
        base_topic = "zigbee2mqtt";
      };
      availability = {
        enabled = true;
      };
      advanced = {
        log_level = "info";
        log_namespaced_levels = {
          "z2m:mqtt" = "warning";
        };
        log_output = [
          "console"
        ];
      };
    };
  };
  systemd.services.zigbee2mqtt.serviceConfig = {
    # zigbee2mqtt stops when the adapter disconnects from the network / the laptop disconnects from the network
    # it happily exits with exit code 0, so let's just always try to restart here
    Restart = lib.mkForce "always";
    RestartSec = 15;
    RestartSteps = 10;
    RestartMaxDelaySec = "5min";
    # Attempt to resolve mDNS issues.
    # TODO(Mindavi): add failure message here and/or create issue upstream.
    CapabilityBoundingSet = lib.mkForce "~";
  };
}
