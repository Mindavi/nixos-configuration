{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "172.16.1.8/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/nixos/secrets/wireguard_key";
        generatePrivateKeyFile = true;
        peers = [
          {
            name = "phone-rick";
            publicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vldO1Gc=";
            persistentKeepalive = 25;
            allowedIPs = [ "172.16.1.1/32" ];
            endpoint = "192.168.1.73:51820";
            #dynamicEndpointRefreshSeconds = 5;
          }
        ];
      };
    };
  };
}
