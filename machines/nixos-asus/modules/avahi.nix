{
  lib,
  config,
  ...
}:

{
  # mDNS doesn't work with TP-Link Deco M5 mesh modules.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    settings = {
      server = {
        domain-name = "local";
      };
      publish = {
        disable-publishing = false;
        publish-addresses = true;
        disable-user-service-publishing = false;
        publish-workstation = true;
      };
    };
  };
}
