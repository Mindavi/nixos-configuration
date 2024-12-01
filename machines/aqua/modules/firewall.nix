{
  pkgs,
  config,
  lib,
  ...
}:
let
  subnetReal = "192.168.1.0/24";
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

  networking.firewall.extraInputRules = ''
    # mdns, zeroconf, avahi TODO(mindavi): probably remove?
    #ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } udp 5353 accept

    # mosquitto (insecure)
    ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } tcp dport 1883 accept

    # samba
    ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } tcp dport { 137, 138, 139, 445 } accept

    # home assistant (FIXME: reverse proxy in front of hass)
    ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } tcp dport 8123 accept

    # Open up 8000 for testing purposes. E.g. running development servers.
    ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } tcp dport 8000 accept

    # rtl_433 http server
    ip saddr { ${subnetReal}, ${subnetVm}, ${subnetWireGuard} } tcp dport 8433 accept
  '';
}
