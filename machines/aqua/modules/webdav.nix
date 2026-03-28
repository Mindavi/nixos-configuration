{ config, ... }:

{
  services.webdav = {
    enable = false;
    user = "webdav";
    group = "webdav";
    settings = {
      # Only serve on wireguard.
      address = "[fd37:191a:d082:555::1]";
      port = "4918";
      users = [
        {
          username = "super";
          password = "my_secret";
        }
      ];
      debug = true;
      # See warning below about systemd.tmpfiles.
      directory = "/storage/documents/webdav/";
      permissions = "CRUD";
    };
  };
  # TODO(Mindavi): route through traefik or setup more strict firewall rules.
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 4918 ];

  systemd.tmpfiles.rules = [
    #"d ${config.services.webdav.settings.directory} 0700 webdav webdav"
  ];
}
