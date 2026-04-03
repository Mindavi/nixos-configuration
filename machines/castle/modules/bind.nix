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
    # Link local scope
    "fe80::/10"
    # Site local scope (also used for wireguard)
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
        master = false;
        # note that impermanence will get rid of this
        # due to how the bind module is written, file is mandatory
        file = "/var/dns/home.arpa.saved";
        allowQuery = allowedNetworks;
        masters = [
          "fd71:a1a4:5a53:0:aaa1:59ff:fe2f:c49c"
          "2a10:3781:5523:0:aaa1:59ff:fe2f:c49c"
        ];
        # file is not defined, meaning that a zone transfer is always needed when bind restarts.
        # TODO(Mindavi): check if we might want to cache the zone data.
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
