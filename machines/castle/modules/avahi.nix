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
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };
  };
}
