{ pkgs, ... }:
{
  imports = [
    ./dashboard.nix
    ./home-assistant.nix
    ./mqtt-sensors.nix
  ];
}
