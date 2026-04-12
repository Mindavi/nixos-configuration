{ lib, config, ... }:

{
  networking.hostName = "aqua";
  # head -c 8 /etc/machine-id
  networking.hostId = "c496aec3";
  networking.networkmanager.enable = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;

  networking.interfaces = lib.optionalAttrs (!isVmBuild) {
    eno1 = {
      # Intentionally enable both DHCP and static IP.
      # This can be handy for recovery when network config is changed.
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.1.8";
          prefixLength = 24;
        }
      ];
      # For IPv6 SLAAC and DHCPv6 are used. No need to define static IPs here.
    };
  };
  dhcpcd.extraConfig = ''
    debug
  '';
}
