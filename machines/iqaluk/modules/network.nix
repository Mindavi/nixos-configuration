{
  lib,
  config,
  ...
}:

{
  systemd.network = {
    enable = true;
    # Disable to prevent blocking boot when wifi (or something else managed by NetworkManager) is used.
    wait-online.enable = false;
    # Ethernet devices: eno1/enp2s0 (closer to the side), enp3s0 (next to USB ports)
    networks."10-enp2s0" = {
      matchConfig.Name = "enp2s0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        #MulticastDNS = "yes";
      };
      # Probably a bit redundant with wait-online.enable = false.
      linkConfig.RequiredForOnline = "no";
    };
  };
  # Extra logging for debugging.
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  networking = {
    hostName = "iqaluk";
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "ab0311dd";
    networkmanager = {
      enable = true;
      unmanaged = [
        "enp2s0"
      ];
      logLevel = "DEBUG";
    };

    useDHCP = false;
    dhcpcd.enable = false;
    useNetworkd = true;

    #nameservers = [
      # aqua
      #"2a10:3781:5523:0:aaa1:59ff:fe2f:c49c"
      # castle
      #"2a10:3781:5523:0:9e6b:ff:fe03:d2f2"
    #];
  };
  services.clatd.enable = true;

  services.resolved = {
    enable = true;
    #settings = {
      #Resolve = {
        #MulticastDNS = "yes";
      #};
    #};
  };
}
