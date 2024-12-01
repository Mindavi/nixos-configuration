{
  config,
  pkgs,
  lib,
  ...
}:

let
  # TODO(Mindavi): consider this: https://discourse.nixos.org/t/detect-build-vm-in-flake/20648
  isVmBuild = builtins.trace ''building as vm: ${lib.boolToString (config.virtualisation ? qemu)}'' (
    config.virtualisation ? qemu
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/backup.nix
    ./modules/fail2ban.nix
    ./modules/firewall.nix
    ./modules/grafana.nix
    ./modules/home-assistant
    ./modules/homepage-dashboard.nix
    ./modules/mosquitto.nix
    ./modules/prometheus.nix
    ./modules/rtl_433.nix
    ./modules/samba.nix
    ./modules/solar-inverter.nix
    ./modules/traefik.nix
    #./modules/virtualisation.nix
    ./modules/wireguard.nix
    ../../modules/hydra.nix
    ../../modules/iperf.nix
    ../../modules/rtl-sdr.nix
    ../../modules/sudo.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "aqua";
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;

  networking.interfaces = lib.optionalAttrs (!isVmBuild) {
    eno1 = {
      # Intentionally enable both DHCP and static IP.
      # This can be handy for recovery when network config is changed.
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.1.8";
          prefixLength = 24;
        }
      ];
      # TODO(Mindavi): ipv6 address.
    };
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    gitAndTools.gitFull
    htop
    jq
    parted
    ripgrep # grep
    screen
    sl
    syncthing
    #transmission_4
    tree
    vim
    zip
  ];

  programs.bash.completion.enable = true;

  # TODO: add syncthing

  services.openssh.enable = true;

  networking.firewall.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/nix"
      "/home"
    ];
  };

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
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    domainName = "local";
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [
      "wheel"
      "networkmanager"
      "dialout"
      "adbusers"
      "plugdev"
    ];
    initialPassword = "rikkert1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus"
    ];
  };
  users.mutableUsers = true;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.05";
}
