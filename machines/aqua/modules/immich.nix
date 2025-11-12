{ pkgs, config, ... }:
{
  services.immich = {
    enable = false;
    port = 2283;
    user = "immich";
    group = "immich"; # TODO(Mindavi): consider users?
    # use traefik instead of opening firewall
    openFirewall = false;
  };
}
