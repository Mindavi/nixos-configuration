{ config, ... }:
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
        # TODO(Mindavi): Rename at some point
        path = "/var/data/samba/copydrive";
        "read only" = false;
        browseable = "yes";
        "guest ok" = "no";
        comment = "Opslag voor gezin";
        "valid users" = "familie";
      };
      shared_documents = {
        path = "/var/data/samba/shared_documents";
        "read only" = false;
        browseable = "no";
        "guest ok" = "no";
        comment = "Gedeelde documenten en bestanden";
        "valid users" = "gedeeld";
      };
      private_documents = {
        path = "/var/data/samba/rick_documents";
        "read only" = false;
        browseable = "no";
        "guest ok" = "no";
        comment = "Persoonlijke documenten en bestanden";
        "valid users" = "rick";
      };
    };
  };

  # inspiration from https://github.com/nix-community/harmonia/blob/b5d77f05256529edbaf574a478d16a8570826789/module.nix#L44-L68
  # and https://github.com/Mic92/sops-nix/issues/198
  systemd.services.samba-smbd.serviceConfig.LoadCredential = [
    "familie_pass:${config.sops.secrets."samba/familie".path}"
    "gedeeld_pass:${config.sops.secrets."samba/gedeeld".path}"
    "rick_pass:${config.sops.secrets."samba/rick".path}"
  ];
  systemd.services.samba-smbd.environment = {
    FAMILIE_PATH = "%d/familie_pass";
    GEDEELD_PATH = "%d/gedeeld_pass";
    RICK_PATH = "%d/rick_pass";
  };
  # inspiration from Mic92 for setting up samba users/passwords:
  # https://github.com/Mic92/dotfiles/blob/8ad994257abd78b940f67593b8500a1c6649c0d7/nixosModules/samba-movieshare.nix#L52C3-L58
  # Some other people also seem to use activation scripts, but this seems more logical to me.
  # Also, how does one get their hands on a smbpasswd file without running a whole samba install before?
  systemd.services.samba-smbd.postStart =
    let
      familie_samba = config.sops.secrets."samba/familie".path;
      gedeeld_samba = config.sops.secrets."samba/gedeeld".path;
      rick_samba = config.sops.secrets."samba/rick".path;
    in
    ''
      (echo $(< ${familie_samba}); echo $(< ${familie_samba})) | ${config.services.samba.package}/bin/smbpasswd -s -a familie
      (echo $(< ${gedeeld_samba}); echo $(< ${gedeeld_samba})) | ${config.services.samba.package}/bin/smbpasswd -s -a gedeeld
      (echo $(< ${rick_samba}); echo $(< ${rick_samba})) | ${config.services.samba.package}/bin/smbpasswd -s -a rick
    '';

  users.groups.familie = { };
  # For adding credentials to Windows:
  # https://superuser.com/questions/973690/windows-10-forgets-mapped-drives-credentials-after-reboot
  users.users.familie = {
    isSystemUser = true;
    home = "/var/data/samba";
    group = "familie";
    extraGroups = [ ];
    # TODO(Mindavi): for setting up the samba password, maybe use activation scripts?
    # https://search.nixos.org/options?channel=unstable&show=system.activationScripts
    # https://discourse.nixos.org/t/nixos-configuration-for-samba/17079/5
  };

  users.groups.gedeeld = { };
  users.users.gedeeld = {
    isSystemUser = true;
    home = "/var/data/samba";
    group = "familie";
    extraGroups = [ ];
    # TODO(Mindavi): for setting up the samba password, maybe use activation scripts?
    # https://search.nixos.org/options?channel=unstable&show=system.activationScripts
    # https://discourse.nixos.org/t/nixos-configuration-for-samba/17079/5
  };
}
