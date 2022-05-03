{ lib, pkgs, config, ... }:
{
  services.grafana = {
    enable = true;
    database = {
      name = "home_assistant";
    };
  };
}
