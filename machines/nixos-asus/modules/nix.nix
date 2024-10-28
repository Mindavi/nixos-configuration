{
  config,
  pkgs,
  ...
}:

{
  nix = {
    package = pkgs.nixVersions.nix_2_24;
    settings = {
      sandbox = true;
      # decrease max number of jobs to prevent highly-parallelizable jobs from context-switching too much
      # see https://nixos.org/manual/nix/stable/#chap-tuning-cores-and-jobs
      max-jobs = 4;
      # since buildCores warns about non-reproducibility, I'll not touch it -- for now.

      trusted-public-keys = [ ];
      substituters = [ ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      builders-use-substitutes = true
      timeout = 86400 # 24 hours
    '';
    gc = {
      automatic = true;
      dates = "02:17";
      randomizedDelaySec = "25min";
      options = "--delete-older-than 30d";
    };
    buildMachines = [ ];
    distributedBuilds = true;
    registry.nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
    nixPath = [ "nixpkgs=${pkgs.path}" ];
  };
}
