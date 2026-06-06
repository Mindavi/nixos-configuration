{
  lib,
  config,
  ...
}:

{
  networking = {
    hostName = "iqaluk";
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "ab0311dd";
    networkmanager.enable = true;

    useDHCP = false;
    interfaces = {
      # Figure out which interfaces are inside.
      # Mostly, just use ipv6 router advertisements for configuration.
      # Ethernet devices: eno1/enp2s0 (closer to the side), enp3s0 (next to USB ports)
    };
    # dhcpcd.enable = false;
    # useNetworkd = true;
  };
  # systemd.network.enable = true;

  services.clatd.enable = true;
}
