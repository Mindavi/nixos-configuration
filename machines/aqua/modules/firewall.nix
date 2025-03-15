{
  pkgs,
  config,
  lib,
  ...
}:
let
  subnetInternal1 = "192.168.1.0/24";
  subnetInternal2 = "192.168.178.0/24";
  subnetVm = "10.0.2.0/24";
  subnetWireGuard = "172.16.1.0/24";
in
{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    logRefusedPackets = true;
    logRefusedConnections = true;
    logRefusedUnicastsOnly = false;
    logReversePathDrops = true;
    rejectPackets = true;
    checkReversePath = true;
  };

  networking.firewall.extraInputRules =
    let
      subnets = lib.concatStringsSep ", " [
        subnetInternal1
        subnetInternal2
        subnetVm
        subnetWireGuard
      ];
    in
    ''
      # mdns, zeroconf, avahi TODO(mindavi): probably remove?
      #ip saddr { ${subnets} } udp 5353 accept

      # mosquitto (insecure)
      ip saddr { ${subnets} } tcp dport 1883 accept

      # samba
      ip saddr { ${subnets} } tcp dport { 137, 138, 139, 445 } accept

      # Open up 8000 for testing purposes. E.g. running development servers.
      ip saddr { ${subnets} } tcp dport 8000 accept

      # rtl_433 http server
      ip saddr { ${subnets} } tcp dport 8433 accept
    '';
}
