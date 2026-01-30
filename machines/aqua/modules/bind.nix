{
  config,
  lib,
  pkgs,
  ...
}:

let
  allowedNetworks = [
    "localhost"
    "localnets"
    # Wireguard range
    "172.16.0.0/16"
  ];
in {
  services.bind = {
    enable = true;

    listenOnPort = 53;
    listenOnIpv6Port = 53;

    # For now just allow on any interface.
    listenOn = [ "any" ];
    listenOnIpv6 = [ "any" ];

    # TODO(Mindavi): enable logging

    cacheNetworks = allowedNetworks;

    forwarders = [
      # Home router
      "192.168.1.1"
      # TODO(Mindavi): IPv6 for home router.
      # AdGuard DNS
      "94.140.14.14"
      "94.140.15.15"
      # AdGuard DNS IPv6
      "2a10:50c0::ad1:ff"
      "2a10:50c0::ad2:ff"
    ];

    # To be able to forward to the addresses that are being determined by the DHCP server
    # in OpenWrt, disable DNSSEC for now. Maybe only for the .lan zone in the future?
    extraOptions = ''
      // Check if the enable switch should be completely off or if validation disabling is enough.
      // dnssec-enable no;
      dnssec-validation no;
    '';

    zones = {
      # https://www.rfc-editor.org/rfc/rfc8375.html
      "home.arpa" = {
        master = true;
        allowQuery = allowedNetworks;
        file = pkgs.writeText "zone-home.arpa" ''
          $TTL 2h
          $ORIGIN home.arpa.
          @               IN      SOA     ns1.home.arpa.   hostmaster.home.arpa. (
                                          2026012901  ; serial number
                                          3h          ; refresh
                                          15m         ; update retry
                                          3w          ; expiry
                                          1h          ; minimum / negative cache TTL
                                          )
          ; name server RR for the domain
                          IN      NS      ns1.home.arpa.

          ns1             IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          ns1             IN      A       192.168.1.8
          aqua            IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          aqua            IN      A       192.168.1.8
          aquav6          IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          hass            IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          hass            IN      A       192.168.1.8
          music-assistant IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          music-assistant IN      A       192.168.1.8
          traefik         IN      AAAA    2a10:3781:5523:0:aaa1:59ff:fe2f:c49c
          traefik         IN      A       192.168.1.8

          ; static DHCP lease
          slzb-06         IN      A       192.168.1.23
        '';

        # TODO(Mindavi): use update-policy instead of this option.
        #   https://bind9.readthedocs.io/en/latest/chapter7.html#dynamic-update-security
        # Allow for dynamic DNS by updating the config at runtime.
        extraConfig = ''
          allow-update { 127.0.0.0/24; ::1; };
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
