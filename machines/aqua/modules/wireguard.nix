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
        ips = [
          "fd37:191a:d082:0555::1/128"
        ];
        listenPort = 51820;
        mtu = 1280;
        privateKeyFile = "/etc/nixos/secrets/wireguard_key";
        generatePrivateKeyFile = true;
        peers = [
          {
            name = "castle";
            publicKey = "A5Gc+c+O+rvAbAYT0VSKT/EmFacDZ/hGopF8xKL6Y2w=";
            allowedIPs = [
              "fd37:191a:d082:555::1d20:9486/128"
            ];
            endpoint = "[2a10:3781:5523:0:9e6b:ff:fe03:d2f2]:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "phone-rick";
            publicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vIdO1Gc=";
            allowedIPs = [
              "fd37:191a:d082:0555::25/128"
            ];
            endpoint = "192.168.1.9:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "nixos-asus";
            publicKey = "uKb3tIPQCTSdQBKvXjQFVT22gj6BHNveP3PSzq9gQBI=";
            allowedIPs = [
              "fd37:191a:d082:0555::2/128"
            ];
            endpoint = "[2a10:3781:5523:0:de53:60ff:fefc:bc9b]:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
        ];
      };
    };
  };
}
