{ pkgs, config, ... }:
{
  services.immich = {
    enable = false;
    port = 2283;
    user = "immich";
    group = "immich"; # TODO(Mindavi): consider users?
    # use traefik instead of opening firewall
    openFirewall = false;
    # let immich use the default for mediaLocation?
    database = {
      enable = false;
      # Explicitly disable since it uses stateVersion and assumes we then always have had immich installed.
      enableVectors = false;
    };
    redis = {
      enable = false;
    };
  };
}
