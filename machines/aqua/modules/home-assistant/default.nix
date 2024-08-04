{ pkgs, ... }:
{
  imports = [
    ./dashboard.nix
    ./home-assistant.nix
  ];
}

