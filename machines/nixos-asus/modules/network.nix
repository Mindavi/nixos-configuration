{
  lib,
  config,
  ...
}:

{
  networking.hostName = "nixos-asus";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  #networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces = {
    wlp2s0 = {
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
    };
  };
  # Prevent waiting for DHCP if running in a VM.
  networking.dhcpcd.wait = "if-carrier-up";
  #systemd.network.wait-online.timeout = 5;
  #systemd.network.wait-online.enable = false;

  #networking.usePredictableInterfaceNames = true;
  #systemd.network.enable = true;
  #networking.useNetworkd = true;

  networking.hosts = {
    "fd71:a1a4:5a53:0:aaa1:59ff:fe2f:c49c" = [
      "aqua"
      "hass.aqua"
    ];
  };
}
