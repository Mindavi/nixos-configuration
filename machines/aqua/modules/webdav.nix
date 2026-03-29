{ config, ... }:

{
  services.webdav = {
    enable = true;
    user = "webdav";
    group = "webdav";
    settings = {
      # Only serve on wireguard.
      address = "[fd37:191a:d082:555::1]";
      port = "4918";
      users = [
        {
          username = "{env}WEBDAV_USERNAME1";
          password = "{env}WEBDAV_PASSWORD1";
        }
      ];
      debug = true;
      directory = "/storage/documents/webdav/";
      permissions = "CRUD";
    };
  };
  # Inject credentials file.
  systemd.services.webdav.serviceConfig.EnvironmentFile = config.sops.secrets."webdav".path;

  # TODO(Mindavi): route through traefik or setup more strict firewall rules.
  # Already only routed through to wireguard, a good start.
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 4918 ];

  systemd.tmpfiles.rules = [
    "d ${config.services.webdav.settings.directory} 0700 webdav webdav"
  ];
}
