{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.bind = {
    enable = true;

    listenOnPort = 53;
    listenOnIpv6Port = 53;

    # For now just allow on any interface.
    listenOn = [ "any" ];
    listenOnIpv6 = [ "any" ];

    # TODO(Mindavi): enable logging

    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
      # Local/home network IPs
      "192.168.1.0/24"
      # Wireguard range
      "172.16.0.0/16"
      # Link local scope
      "fe80::/10"
      # Site local scope
      "fc00::/7"
    ];

    forwarders = [
      # AdGuard DNS
      "94.140.14.14"
      "94.140.15.15"
      # AdGuard DNS IPv6
      "2a10:50c0::ad1:ff"
      "2a10:50c0::ad2:ff"
    ];

    zones = {
      # https://www.rfc-editor.org/rfc/rfc8375.html
      "home.arpa" = {
        master = true;
        allowQuery = [
          "127.0.0.0/24"
          "::1/128"
          # TODO(Mindavi): local/home network IPs.
          "192.168.1.0/24"
          # Link local scope
          "fe80::/10"
          # Site local scope
          "fc00::/7"
        ];
        file = pkgs.writeText "zone-home.arpa" ''
          $TTL 2h
          $ORIGIN home.arpa.
          @               IN      SOA     ns1.home.arpa.   hostmaster.home.arpa. (
                                          2026012601  ; serial number
                                          3h          ; refresh
                                          15m         ; update retry
                                          3w          ; expiry
                                          1h          ; minimum / negative cache TTL
                                          )
          ; name server RR for the domain
                          IN      NS      ns1.home.arpa.

          ns1             IN      A       192.168.1.8
          aqua            IN      A       192.168.1.8
          hass            IN      A       192.168.1.8
          music-assistant IN      A       192.168.1.8
          traefik         IN      A       192.168.1.8
        '';

        # TODO(Mindavi): use update-policy instead of this option.
        #   https://bind9.readthedocs.io/en/latest/chapter7.html#dynamic-update-security
        # Allow for dynamic DNS by updating the config at runtime.
        extraConfig = ''
          allow-update = { 127.0.0.1/24; ::1; }
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
