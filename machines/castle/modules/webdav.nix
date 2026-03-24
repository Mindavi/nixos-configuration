{ config, ... }:

{
  services.webdav = {
    enable = true;
    user = "webdav";
    group = "webdav";
    settings = {
      address = "[fd37:191a:d082:555::1d20:9486]";
      port = "4918";
      users = [
        {
          username = "super";
          password = "my_secret";
        }
      ];
      directory = "/srv/public";
      permissions = "RW";
    };
  };
  # TODO(Mindavi): route through traefik or setup more strict firewall rules.
  networking.firewall.allowedTCPPorts = [ 4918 ];
}
