{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    # only open firewall to internal network, see firewall.nix
    openFirewall = false;
    shares.copydrive = {
      path = "/home/rick/data/samba/copydrive";
      "read only" = true;
      browseable = "yes";
      "guest ok" = "no";
      comment = "Opslag voor gezin";
    };
    # TODO: add users (here?) -> Maybe we just want to sync with the unix users somehow?
    # username: familie
  };
}

