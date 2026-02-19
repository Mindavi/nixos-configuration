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
        ips = [ "fd37:191a:d082:555::1d20:9486/96" ];
        listenPort = 51820;
        mtu = 1280;
        privateKeyFile = "/etc/nixos/secrets/wireguard_key";
        generatePrivateKeyFile = true;
        peers = [
          {
            name = "aqua";
            publicKey = "D23jZc9k02dKnamHUAagtZPwrPAD0W40YWC6Pp5yP00=";
            allowedIPs = [ "fd37:191a:d082:555::1/128" ];
            endpoint = "[2a10:3781:5523:0:aaa1:59ff:fe2f:c49c]:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "nixos-asus";
            publicKey = "uKb3tIPQCTSdQBKvXjQFVT22gj6BHNveP3PSzq9gQBI=";
            allowedIPs = [ "fd37:191a:d082:555::2/128" ];
            endpoint = "[2a10:3781:5523:0:de53:60ff:fefc:bc9b]:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "phone-rick";
            publicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vIdO1Gc=";
            allowedIPs = [ "fd37:191a:d082:555::25/128" ];
            endpoint = "192.168.1.9:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
        ];
      };
    };
  };
}
