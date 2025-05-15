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
      # mosquitto (insecure)
      ip saddr { ${subnets} } tcp dport 1883 accept

      # samba
      ip saddr { ${subnets} } tcp dport { 137, 138, 139, 445 } accept

      # Open up 8000 for testing purposes. E.g. running development servers.
      ip saddr { ${subnets} } tcp dport 8000 accept

      # rtl_433 http server
      ip saddr { ${subnets} } tcp dport 8433 accept

      # music assistant custom stream port
      ip saddr { ${subnets} } tcp dport 8097 accept
      # squeezelite / slimproto / music assistant
      ip saddr { ${subnets} } tcp dport 3483 accept

      # enable multicast support (avahi, upnp)
      # taken and adapted from nixos/modules/services/audio/roon-server.nix
      # port 5353 is already opened by avahi, but IGMP packets seem to be dropped too
      ip saddr { 224.0.0.0/4, 240.0.0.0/5 } accept
      ip daddr 224.0.0.0/4 accept
      pkttype { multicast, broadcast } accept
    '';
}
