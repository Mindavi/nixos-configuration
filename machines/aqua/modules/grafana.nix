{
  config,
  lib,
  ...
}:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 2342;
        http_addr = "127.0.0.1";
        serve_from_sub_path = false;
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/";
      };
      security.secret_key = "$__file{${config.sops.secrets."grafana/secret_key".path}}";
    };
  };
}
