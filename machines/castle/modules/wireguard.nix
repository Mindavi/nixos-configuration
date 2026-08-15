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
  systemd.network = {
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "fd37:191a:d082:555::1d20:9486/128"
      ];
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = 1280;
      };
      wireguardConfig = {
        ListenPort = 51820;
        # TODO(Mindavi): figure out automatically generating this. Or store with sops?
        PrivateKeyFile = "/etc/nixos/secrets/wireguard_key";
        # TODO(Mindavi): is this needed?
        # RouteTable = "main";
      };
      wireguardPeers = [
        {
          # aqua
          PublicKey = "D23jZc9k02dKnamHUAagtZPwrPAD0W40YWC6Pp5yP00=";
          AllowedIPs = [ "fd37:191a:d082:555::1/128" ];
          Endpoint = "[2a10:3781:5523:0:aaa1:59ff:fe2f:c49c]:51820";
        }
        {
          # nixos-asus
          PublicKey = "uKb3tIPQCTSdQBKvXjQFVT22gj6BHNveP3PSzq9gQBI=";
          AllowedIPs = [ "fd37:191a:d082:555::2/128" ];
          Endpoint = "[2a10:3781:5523:0:de53:60ff:fefc:bc9b]:51820";
        }
        {
          # phone rick 1
          PublicKey = "BgCzrwWKlyV+zz1LqkxeedKJOdgdnXQs+U4/vIdO1Gc=";
          AllowedIPs = [ "fd37:191a:d082:555::25/128" ];
          Endpoint = "192.168.1.9:51820";
        }
        {
          # phone rick 2
          PublicKey = "n9c6XYkJoPunqSsg86qhaK9zXEXwdpTIv01cruFogHk=";
          AllowedIPs = [
            "fd37:191a:d082:555:af16:4465:9f79:ba81/128"
          ];
          Endpoint = "[2a10:3781:5523:0:b048:eaff:fedb:d09a]:51820";
        }
      ];
    };
  };
}
