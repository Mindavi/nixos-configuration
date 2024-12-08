{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    # only open firewall to internal network, see firewall.nix
    openFirewall = false;
    settings.copydrive = {
      path = "/var/data/samba/copydrive";
      "read only" = false;
      browseable = "yes";
      "guest ok" = "no";
      comment = "Opslag voor gezin";
    };
  };
  users.groups.familie = { };
  # For adding credentials to Windows:
  # https://superuser.com/questions/973690/windows-10-forgets-mapped-drives-credentials-after-reboot
  users.users.familie = {
    isSystemUser = true;
    home = "/var/data/samba";
    group = "familie";
    extraGroups = [ ];
    initialPassword = "familie";
  };
}
