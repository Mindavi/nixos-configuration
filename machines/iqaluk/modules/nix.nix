{
  config,
  nixos-unstable,
  pkgs,
  ...
}:

{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      sandbox = true;
      max-jobs = 8;
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
      dates = "weekly";
      randomizedDelaySec = "25min";
      options = "--delete-older-than 30d";
      persistent = true;
    };
    buildMachines = [ ];
    distributedBuilds = true;
    # https://github.com/ryan4yin/nixos-and-flakes-book/blob/main/docs/best-practices/nix-path-and-flake-registry.md
    # https://github.com/stephen-huan/nixos-config/issues/1
    # https://github.com/NixOS/nix/issues/9574
    channel.enable = false;
    registry.nixpkgs.flake = nixos-unstable;
    # nixPath = [ "nixpkgs=${pkgs.path}" ];

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

  nixpkgs.config = {
    # Even though it's not recommended, I'm going to enable this anyway.
    # I like it to be a hard error when an attribute is renamed or whatever.
    # Can always disable this again when it causes issues.
    allowAliases = false;
    #contentAddressedByDefault = true;
    #strictDepsByDefault = true;
    # error: The `env` attribute set cannot contain any attributes passed to derivation. The following attributes are overlapping:
    # - BASH_SHELL: in `env`: "/bin/sh"; in derivation arguments: "/bin/sh"
    # - NIX_CFLAGS_COMPILE: in `env`: ""; in derivation arguments: ""
    # - is64bit: in `env`: true; in derivation arguments: true
    # - linuxHeaders: in `env`: <derivation linux-headers-6.9>; in derivation arguments: <derivation linux-headers-6.9>
    #structuredAttrsByDefault = true;
  };
}
