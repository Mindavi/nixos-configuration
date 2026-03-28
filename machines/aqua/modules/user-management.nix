{ config, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/rick";
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "networkmanager"
      "plugdev"
      "wheel"
    ];
    initialPassword = "rikkert1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus"
    ];
  };
  users.mutableUsers = true;
  services.userborn.enable = true;
}
