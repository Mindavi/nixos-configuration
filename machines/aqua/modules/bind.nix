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
    # Local/home network IPs
    "192.168.1.0/24"
    # Wireguard range
    "172.16.0.0/16"
    # Link local scope
    "fe80::/10"
    # Site local scope
    "fc00::/7"
  ];
in
{
  networking.resolvconf.useLocalResolver = false;
  services.bind = {
    enable = true;

    # Note: by default this sets `networking.resolvconf.useLocalResolver` to true.
    # This may mean that DNS breaks on this system whenever BIND fails to start up.
    # Consider setting it to false, maybe?

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
      dnssec-validation no;
    '';

    extraConfig = ''
      logging {
          category default { default_syslog; };
          category queries { default_syslog; };
          category query-errors { default_syslog; };
          category config { default_syslog; };
          category resolver { default_syslog; };
      };
    '';

    # split horizon example: https://github.com/lopsided98/nixos-config/blob/b000df92c20d79a58d56f755ff8af2cabb69b090/modules/config/dns.nix
    zones = {
      # https://www.rfc-editor.org/rfc/rfc8375.html
      "home.arpa" = {
        master = true;
        allowQuery = allowedNetworks;
        file = pkgs.writeText "zone-home.arpa" ''
          $TTL 2h
          $ORIGIN home.arpa.
          @               IN      SOA     ns1.home.arpa.   hostmaster.home.arpa. (
                                          2026020101  ; serial number
                                          3h          ; refresh
                                          15m         ; update retry
                                          3w          ; expiry
                                          1h          ; minimum / negative cache TTL
                                          )
          ; name server RR for the domain
                          IN      NS      ns1.home.arpa.

          ns1             IN      AAAA    fd37:191a:d082:555::1
          aqua            IN      AAAA    fd37:191a:d082:555::1
          aqua            IN      A       172.16.1.8
          dashboard       IN      AAAA    fd37:191a:d082:555::1
          grafana         IN      AAAA    fd37:191a:d082:555::1
          hass            IN      AAAA    fd37:191a:d082:555::1
          home-assistant  IN      AAAA    fd37:191a:d082:555::1
          hydra           IN      AAAA    fd37:191a:d082:555::1
          music-assistant IN      AAAA    fd37:191a:d082:555::1
          photos          IN      AAAA    fd37:191a:d082:555::1
          prometheus      IN      AAAA    fd37:191a:d082:555::1
          syncthing       IN      AAAA    fd37:191a:d082:555::1
          traefik         IN      AAAA    fd37:191a:d082:555::1
          zigbee2mqtt     IN      AAAA    fd37:191a:d082:555::1

          ; static DHCP lease
          slzb-06         IN      A       192.168.1.23
        '';

        # TODO(Mindavi): use update-policy instead of this option.
        #   https://bind9.readthedocs.io/en/latest/chapter7.html#dynamic-update-security
        # Allow for dynamic DNS by updating the config at runtime.
        # extraConfig = ''
        #   allow-update { 127.0.0.0/24; ::1; };
        # '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
