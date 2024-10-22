{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
  systemd.network.netdevs.wg0.wireguardPeers = [
    {
      wireguardPeerConfig = {
        AllowedIPs = [
          "172.16.1.1/32"
        ];
        EndPoint = "192.168.1.80:51820";
        PersistentKeepAlive = 30;
        PublicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vldO1Gc=";
      };
    }
  ];
};