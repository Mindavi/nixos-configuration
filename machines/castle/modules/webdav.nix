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
      debug = true;
      # See warning below about systemd.tmpfiles.
      directory = "/srv/public";
      permissions = "CRUD";
    };
  };
  # TODO(Mindavi): route through traefik or setup more strict firewall rules.
  networking.firewall.allowedTCPPorts = [ 4918 ];

  systemd.tmpfiles.rules = [
    # Careful! This will remove the directory contents if it already exists.
    "D ${config.services.webdav.settings.directory} 0755 webdav webdav"
  ];
}
