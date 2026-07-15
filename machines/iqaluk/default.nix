{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/audio.nix
    ./modules/avahi.nix
    ./modules/backup.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/disko.nix
    ./modules/environment.nix
    ./modules/firewall.nix
    ./modules/gaming.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/nix.nix
    ./modules/postgres.nix
    ./modules/printer-scanner.nix
    ./modules/prometheus.nix
    ./modules/syncthing.nix
    ./modules/users.nix
    ./modules/wireguard.nix
    ../../modules/iperf.nix
    ../../modules/sudo.nix
    ../../modules/zfs.nix
  ];

  system.stateVersion = "26.05";
}
