{
  ...
}:

{
  # userborn causes issues during install: https://github.com/NixOS/nixpkgs/issues/408507
  services.userborn.enable = false;
  # ... so use systemd-sysusers for now
  systemd.sysusers.enable = true;

  users = {
    mutableUsers = true;
    users.rick = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/rick";
      extraGroups = [
        "wheel"
        "networkmanager"
        "dialout"
        "adbusers"
        "plugdev"
        "kvm"
        "scanner"
      ];
      initialHashedPassword = "$y$j9T$twhqx7hDMDomRpaMmuW5N/$kkZ0xgra4QHp5QHeDTZRtOKKFM3tOC79WwMjEI2FLB1";
      linger = false;
    };
    users.josha = {
      isNormalUser = true;
      uid = 1001;
      home = "/home/josha";
      extraGroups = [
        "networkmanager"
        "dialout"
        "kvm"
        "scanner"
      ];
      initialHashedPassword = "$y$j9T$APj7UNYwq9VRC9JAe2zx//$Wmd6xZCtPz2cXza5fv5y9nOYRos5YAKn7j7cP5eTv01";
      linger = false;
    };
  };
}
