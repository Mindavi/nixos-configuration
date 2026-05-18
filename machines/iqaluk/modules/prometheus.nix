{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
        ];
      };
    };
  };

  networking.firewall.interfaces.wg0.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
  ];
}
