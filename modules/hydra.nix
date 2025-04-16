{
  config,
  pkgs,
  ...
}:
let
  hydra_exporter = pkgs.callPackage ../packages/hydra_exporter { };
  hydra_exporter_port = 9200;
  hydraqueuerunner_port = 9198;
in
{
  # hydra is available on http://localhost:3000/
  services.hydra = {
    enable = true;
    package = (
      pkgs.hydra.overrideAttrs (oldAttrs: {
        version = oldAttrs.version + "-mindavi";
        patches = (oldAttrs.patches or [ ]) ++ [
          # https://github.com/NixOS/hydra/pull/875
          #./patches/nixos-hydra-pull-875.patch
        ];
      })
    );
    #.override {
    #  nix = pkgs.nixVersions.nix_2_22;
    #};
    hydraURL = "http://localhost:${toString config.services.hydra.port}";
    port = 3000;
    notificationSender = "hydra@localhost";
    # Enable to only use localhost, disable or set to /etc/nix/machines to enable remote builders as well.
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    extraConfig = ''
      # Uses quite a bit of memory, so prevent multiple evals at once to reduce chance of memory exhaustion.
      max_concurrent_evals = 1
    '';
    extraEnv = {
      #"HYDRA_DEBUG" = "1";
    };
  };
  systemd.services.hydra-send-stats.enable = false;
  networking.firewall.allowedTCPPorts = [
    # Hydra web server port.
    config.services.hydra.port
    # hydraqueuerunner prometheus metrics port.
    hydraqueuerunner_port
    # Port for hydra-exporter
    hydra_exporter_port
  ];

  systemd.services.hydra-exporter = {
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "hydra-evaluator.service"
    ];
    after = [
      "network-online.target"
      "hydra-evaluator.service"
    ];
    description = "hydra queue runner stats exporter";
    environment = { };
    serviceConfig = {
      Type = "exec";
      ExecStart = "${hydra_exporter}/bin/hydra_exporter --collector.queue-runner.url=\"${config.services.hydra.hydraURL}/queue-runner-status\" --web.listen-address=:${toString hydra_exporter_port}";
      DynamicUser = "yes";
      Restart = "on-failure";
      RestartSec = "30s";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      WorkingDirectory = "/tmp";
    };
  };
}
