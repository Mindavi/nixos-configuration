{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.prometheus = {
    enable = false;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
        ];
      };
      smartctl = {
        enable = true;
      };
    };
  };

  networking.firewall.interfaces.wg0.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
    config.services.prometheus.exporters.smartctl.port
  ];
}
