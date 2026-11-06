{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.avahi = {
    enable = false;
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
