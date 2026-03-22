{ config, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    hostkeys = [
      {
        bits = 4096;
        path = "/persist/castle/ssh_host_keys/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/castle/ssh_host_keys/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
