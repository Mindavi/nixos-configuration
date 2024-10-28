{
  config,
  pkgs,
  ...
}:
let
  hydra_exporter = pkgs.callPackage ../packages/hydra_exporter {};
in
{
  # hydra is available on http://localhost:3000/
  services.hydra = {
    enable = true;
    package = (
      pkgs.hydra.overrideAttrs (oldAttrs: {
        version = oldAttrs.version + "-mindavi";
        patches =
          # oldAttrs.patches or
          ([ ]) ++ [
            # https://github.com/NixOS/hydra/pull/1372
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/hydra/commit/8e7746d1e38776554a312da5491b98f86a80de76.patch";
              name = "show-build-step-names.patch";
              hash = "sha256-7CUfoXzzzfjNU2IyxvGhGbDg3lVdI8K3FQovUOQvh5E=";
            })
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/hydra/commit/bd380f694e71e1b9bff7db2f12de6ade94a1edd2.patch";
              name = "only-show-stepname-not-equal-drv-name.patch";
              hash = "sha256-OtNmdLHvsa2XPlSkJM2hH1zi/igcRTX40qq9PNTtpAI=";
            })
            # https://github.com/NixOS/hydra/pull/1417
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/hydra/commit/2a7b070da0ef2b2f23e4331282ba6e013690edb0.patch";
              name = "nix-prefetch-git_set-branch-name.patch";
              hash = "sha256-qgbzxJazYBERsTKCGZyxQ0rl+h6NpHFx70LYV/8hnlU=";
            })
            # https://github.com/NixOS/hydra/pull/1416
            # https://github.com/NixOS/hydra/commit/8a54924d2aeffa841a3764b2c916211a8219c34c.patch
            (pkgs.fetchpatch2 {
              url = "https://github.com/NixOS/hydra/commit/8a54924d2aeffa841a3764b2c916211a8219c34c.patch";
              name = "S3Backup-fix-compilation-issue.patch";
              hash = "sha256-3UNI2dEemS1u/DXGayyUegC82ju9RVj8x6MlL+MCrxg=";
            })
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
  };
  systemd.services.hydra-send-stats.enable = false;
  # networking.firewall.allowedTCPPorts = [
  #   config.services.hydra.port
  # ];

  networking.firewall.allowedTCPPorts = [ 9200 ];
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
    environment = {};
    serviceConfig = {
      Type = "exec";
      ExecStart = "${hydra_exporter}/bin/hydra_exporter --collector.queue-runner.url=\"${config.services.hydra.hydraURL}\" --web.listen-address=:9200";
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
