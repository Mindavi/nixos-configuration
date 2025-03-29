{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    openttd
    #polymc
    zeroad
    zeroad-data
  ];
}
