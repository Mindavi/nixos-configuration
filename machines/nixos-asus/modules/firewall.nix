{
  config,
  pkgs,
  lib,
  ...
}:

let
  subnetReal = "192.168.1.0/24";
  subnetWireGuard = "172.16.1.0/24";
in
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
  networking.firewall = {
    enable = true;
    logRefusedPackets = true;
    logRefusedConnections = true;
    logRefusedUnicastsOnly = false;
    logReversePathDrops = true;
    rejectPackets = true;
    checkReversePath = true;

    extraInputRules = ''
      # Open up 8000 for testing purposes. E.g. running development servers.
      ip saddr { ${subnetReal}, ${subnetWireGuard} } tcp dport 8000 accept

      # prometheus node_exporter
      ip saddr { ${subnetWireGuard} } tcp dport ${toString config.services.prometheus.exporters.node.port} accept
    '';
  };
}
