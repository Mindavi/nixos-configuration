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
    # TODO: add users (here?) -> Maybe we just want to sync with the unix users somehow?
    # username: familie
  };
  users.users.familie = {
    isSystemUser = true;
    home = "/var/data/samba";
    extraGroups = [ ];
    initialPassword = "familie";
  };
  users.users.familie.group = "familie";
  users.groups.familie = {};
}

