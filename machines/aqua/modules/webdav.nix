{ config, ... }:

{
  services.webdav-server-rs = {
    enable = true;
    settings = {
      server.listen = [
        # "0.0.0.0:4918"
        # "[::]:4918"
        "[fd37:191a:d082:0555::1]:4918"
      ];
      accounts = {
        # auth-type = "htpasswd.default";
        auth-type = "pam";
        acct-type = "unix";
        realm = "Webdav server";
      };
      unix = {
        cache-timeout = 120;
        min-uid = 1000;
      };
      # htpasswd.default = {
      #   htpasswd = "/etc/htpasswd";
      # };
      location = [
        {
          route = [ "/user/:user/*path" ];
          directory = "~";
          handler = "filesystem";
          methods = [ "webdav-rw" ];
          autoindex = true;
          auth = "true";
          setuid = true;
        }
      ];
    };
  };
  # TODO(Mindavi): route through traefik or setup more strict firewall rules.
  networking.firewall.allowedTCPPorts = [ 4918 ];
}
