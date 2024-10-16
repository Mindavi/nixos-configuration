{ pkgs, config, ... }:
{
  services.hydra = {
    enable = true;
    port = 3001;
    hydraURL = "http://localhost:3001";
    notificationSender = "hydra@localhost";
    # Enable to only use localhost, disable or set to /etc/nix/machines to enable remote builders as well.
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };

  networking.firewall.allowedTCPPorts = [
    config.services.hydra.port
  ];
}
