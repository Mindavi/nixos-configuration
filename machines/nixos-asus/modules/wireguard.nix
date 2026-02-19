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
          "fd37:191a:d082:0555::2/128"
        ];
        listenPort = 51820;
        mtu = 1280;
        privateKeyFile = "/etc/nixos/secrets/wireguard_key";
        generatePrivateKeyFile = true;
        peers = [
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
            name = "aqua";
            # TODO(mindavi): add networking.wireguard.interfaces.<name>.peers.*.presharedKeyFile
            publicKey = "D23jZc9k02dKnamHUAagtZPwrPAD0W40YWC6Pp5yP00=";
            allowedIPs = [
              "fd37:191a:d082:0555::1/128"
            ];
            endpoint = "192.168.1.8:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "castle"
            publicKey = "A5Gc+c+O+rvAbAYT0VSKT/EmFacDZ/hGopF8xKL6Y2w=";
            allowedIPs = [
              "fd37:191a:d082:555::1d20:9486/128"
            ];
            endpoint = "[2a10:3781:5523:0:9e6b:ff:fe03:d2f2]:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
        ];
      };
    };
  };
}
