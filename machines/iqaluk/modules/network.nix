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
    };
    # dhcpcd.enable = false;
    # useNetworkd = true;
  };
  # systemd.network.enable = true;

  services.clatd.enable = true;
}
