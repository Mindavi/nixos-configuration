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
    prismlauncher
    # zeroad got dropped from nixpkgs: https://github.com/NixOS/nixpkgs/pull/585016
    #zeroad
    #zeroad-data
  ];

  nixpkgs.config.allowUnfreePackages = [
    "discord"
    "discord-unwrapped"
    "steam"
    "steam-original"
    "steam-run"
    "steam-runtime"
    "steam-unwrapped"
  ];
}
