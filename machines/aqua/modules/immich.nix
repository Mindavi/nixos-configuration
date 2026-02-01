{ pkgs, config, ... }:
{
  services.immich = {
    enable = true;
    port = 2283;
    user = "immich";
    group = "gedeeld";
    # use traefik instead of opening firewall
    openFirewall = false;
    # let immich use the default for mediaLocation?
    database = {
      enable = true;
      # Explicitly disable since it uses stateVersion and assumes we then always have had immich installed.
      enableVectors = false;
      enableVectorChord = true;
    };
    redis = {
      enable = true;
    };
    machine-learning.enable = true;
    mediaLocation = "/storage/documents/samba/shared_documents/Fotos";
  };
}
