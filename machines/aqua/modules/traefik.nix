{ pkgs, config, ... }:
let
  port = 8000;  # use 8000 for experimentation
in {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":${toString port}";
        };
        websecure = {
          address = ":443";
        };
      };
      api.dashboard = true;
      accesslog = true;
      #certificatesResolvers.le.acme = {
        #email = "rol3517@gmail.com";
        #storage = "letsencrypt/acme.json";  # FIXME: probably somewhere in /var/?
        #httpChallenge.entryPoint = "web";
      #};
    };
    dynamicConfigOptions = {
      http = {
        routers.api = {
          entrypoints = "web";
          # TODO: change Host rule to traefik.rickvanschijndel.eu
          rule = "Host(`traefik.localhost`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
          service = "api@internal";
          middlewares = "internal-whitelist";
        };
        # TODO: change source range to 192.168.2.0/24
        middlewares.internal-whitelist.ipwhitelist.sourcerange = "10.0.2.0/24";

        routers.homeassistant = {
          # TODO: change to home.rickvanschijndel.eu
          rule = "Host(`home.localhost`)";
          # TODO: change to websecure
          entrypoints = "web";
          #tls = true;
          #tls.certresolver = "le";
          service = "homeassistant";
        };
        services.homeassistant = {
          loadBalancer.servers.url = "http://localhost:8123";
        };
      };
    };
  };

  # use 8000 for testing since it's easier to open up for now
  networking.firewall.allowedTCPPorts = [ 80 443 ] ++ [ port ];
}

