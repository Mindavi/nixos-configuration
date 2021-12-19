{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/firewall.nix
      ./modules/home-assistant.nix
      ./modules/samba.nix
      ./modules/traefik.nix
      ../../modules/iperf.nix
      ../../modules/rtl-sdr.nix
      ../../modules/sudo.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "aqua";
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;

  #networking.interfaces.<tbd>.useDHCP = true;

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    gitAndTools.gitFull
    htop
    jq
    ripgrep # grep
    #rtl_433
    screen
    sl
    syncthing
    transmission
    tree
    vim
    zip
  ];

  programs.bash.enableCompletion = true;

  # TODO: add hydra, syncthing

  services.openssh.enable = true;

  networking.firewall.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      builders-use-substitutes = true
      timeout = 86400 # 24 hours
    '';
    binaryCaches = [
      "https://cache.ngi0.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    buildMachines = [];
    distributedBuilds = true;

    # decrease max number of jobs to prevent highly-parallelizable jobs from context-switching too much
    # see https://nixos.org/manual/nix/stable/#chap-tuning-cores-and-jobs
    maxJobs = 4;
    # since buildCores warns about non-reproducibility, I'll not touch it -- for now.
  };

  services.avahi = {
    domainName = "local";
    enable = true;
    interfaces = [ "wlp2s0" ];  # TODO: change to correct interface
    nssmdns = true;
    openFirewall = true;
  };

  # e.g. platformio and element use this, so make sure this is enabled.
  security.unprivilegedUsernsClone = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [ "wheel" "networkmanager" "dialout" "adbusers" "plugdev" ];
    initialPassword = "rikkert";
    openssh.authorizedKeys.keys =  [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus" ];
  };

  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "21.11";
}

