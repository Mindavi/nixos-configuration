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
    #zeroad
    # Make sure that at least the data is here.
    zeroadPackages.zeroad-data
  ];
}
