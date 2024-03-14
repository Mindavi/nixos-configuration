{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    # only open firewall to internal network, see firewall.nix
    openFirewall = false;
    shares.copydrive = {
      path = "/var/data/samba/copydrive";
      "read only" = true;
      browseable = "yes";
      "guest ok" = "no";
      comment = "Opslag voor gezin";
    };
  };
  users.groups.familie = {};
  users.users.familie = {
    isSystemUser = true;
    home = "/var/data/samba";
    group = "familie";
    extraGroups = [ ];
    initialPassword = "familie";
  };
}

