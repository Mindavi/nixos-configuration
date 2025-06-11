{
  config,
  nixos-unstable,
  pkgs,
  ...
}:

{
  nix = {
    package = pkgs.nixVersions.nix_2_29;
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
    # https://github.com/ryan4yin/nixos-and-flakes-book/blob/main/docs/best-practices/nix-path-and-flake-registry.md
    # https://github.com/stephen-huan/nixos-config/issues/1
    # https://github.com/NixOS/nix/issues/9574
    channel.enable = false;
    registry.nixpkgs.flake = nixos-unstable;
    # nixPath = [ "nixpkgs=${pkgs.path}" ];
  };
}
