{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.avahi = {
    enable = false;
    domainName = "local";
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    settings = {
      publish = {
        disable-publishing = false;
        publish-addresses = true;
        disable-user-service-publishing = false;
        publish-workstation = true;
      };
    };
  };
}
