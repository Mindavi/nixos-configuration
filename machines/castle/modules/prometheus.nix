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
    };
  };
}
