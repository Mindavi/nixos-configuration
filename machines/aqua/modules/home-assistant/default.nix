{ pkgs, ... }:
{
  imports = [
    ./dashboard.nix
    ./home-assistant.nix
    ./input-number.nix
    ./mqtt-sensors.nix
    ./sensors.nix
  ];
}
