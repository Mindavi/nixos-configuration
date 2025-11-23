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
        ips = [ "172.16.1.2/24" ];
        listenPort = 51820;
        mtu = 1280;
        privateKeyFile = "/etc/nixos/secrets/wireguard_key";
        generatePrivateKeyFile = true;
        peers = [
          {
            name = "phone-rick";
            publicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vIdO1Gc=";
            allowedIPs = [ "172.16.1.1/32" ];
            endpoint = "192.168.1.9:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
          {
            name = "aqua";
            # TODO(mindavi): add networking.wireguard.interfaces.<name>.peers.*.presharedKeyFile
            publicKey = "D23jZc9k02dKnamHUAagtZPwrPAD0W40YWC6Pp5yP00=";
            allowedIPs = [ "172.16.1.8/32" ];
            endpoint = "45.83.240.221:51820";
            dynamicEndpointRefreshSeconds = 5;
            dynamicEndpointRefreshRestartSeconds = 60;
          }
        ];
      };
    };
  };
}
