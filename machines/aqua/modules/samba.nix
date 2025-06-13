{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    # only open firewall to internal network, see firewall.nix
    openFirewall = false;
    settings = {
      global = {
        "invalid users" = [
          "root"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
        "map to guest" = "Never";
      };
      copydrive = {
        path = "/var/data/samba/copydrive";
        "read only" = false;
        browseable = "yes";
        "guest ok" = "no";
        comment = "Opslag voor gezin";
        "valid users" = "familie";
      };
    };
  };
  users.groups.familie = { };
  # For adding credentials to Windows:
  # https://superuser.com/questions/973690/windows-10-forgets-mapped-drives-credentials-after-reboot
  users.users.familie = {
    # Should probably be false?
    isSystemUser = true;
    home = "/var/data/samba";
    group = "familie";
    extraGroups = [ ];
    # TODO(Mindavi): for setting up the samba password, maybe use activation scripts?
    # https://search.nixos.org/options?channel=unstable&show=system.activationScripts
    initialPassword = "familie";
  };
}
