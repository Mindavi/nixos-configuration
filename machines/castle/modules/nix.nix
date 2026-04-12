{
  ...
}:
{
  nix = {
    settings = {
      sandbox = true;
      # decrease max number of jobs to prevent highly-parallelizable jobs from context-switching too much
      # see https://nixos.org/manual/nix/stable/#chap-tuning-cores-and-jobs
      max-jobs = 4;
      # since buildCores warns about non-reproducibility, I'll not touch it -- for now.
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      builders-use-substitutes = true
      timeout = 86400 # 24 hours
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    buildMachines = [ ];
    distributedBuilds = true;

    firewall = {
      enable = true;
      # Inspiration: https://github.com/NixOS/nixpkgs/pull/464613#issuecomment-3638093484
      allowedTCPPorts = [
        22 # SSH (for git+ssh:// URLs)
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [
        53 # DNS
        443 # QUIC/HTTP3
      ];
    };
  };
}
