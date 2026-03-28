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
    };
    redis = {
      enable = true;
    };
    machine-learning.enable = true;
    mediaLocation = "/storage/documents/samba/shared_documents/Fotos";
  };
  # TODO(Mindavi): systemd-tmpfiles logged this:
  # Detected unsafe path transition /storage/documents/samba/shared_documents (owned by gedeeld) → /storage/documents/samba/shared_documents/Fotos (owned by immich) during canonicalization of storage/documents/samba/shared_documents/Fotos.
}
