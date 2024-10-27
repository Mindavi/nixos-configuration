{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Open ports in the firewall.
  # 25565 for minecraft
  # 6567 for mindustry
  # 51413 for transmission
  # 5201 for iperf3
  # 5000 for development servers
  # 8080 for development servers
  networking.firewall.allowedTCPPorts = [
    #25565
    #6567
    #51413
    #5201
    5000
    8080
  ];
  # 20595 for 0ad
  # 6567 for mindustry
  networking.firewall.allowedUDPPorts = [
    20595
    #6567
  ];
  networking.nftables.enable = true;
  networking.firewall.enable = true;
  networking.firewall.logRefusedPackets = true;
  networking.firewall.logRefusedConnections = true;
  networking.firewall.logRefusedUnicastsOnly = false;
  networking.firewall.logReversePathDrops = true;
  networking.firewall.rejectPackets = true;
  networking.firewall.checkReversePath = true;
}
