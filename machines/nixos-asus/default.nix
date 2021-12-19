{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gaming.nix
      ../../modules/sudo.nix
      ../../modules/rtl-sdr.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 7;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "nixos-asus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  #networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking.hosts = {
    "192.168.2.8" = [ "aqua" ];
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    # rust cli tools
    exa # ls
    bat # cat
    ripgrep # grep
    fzf # fuzzy find

    pciutils
    wget
    vim
    firefox
    htop
    gitAndTools.gitFull
    keepassxc
    tree
    sl
    vlc
    syncthing
    #transmission
    fping
    vscodium
    jq
    libreoffice
    file
    zip
    screen
    p7zip
    digikam
    fdupes

    # pdf viewer
    okular

    # photo viewer
    nomacs

    # communication
    element-desktop
    irssi
    thunderbird
    tdesktop

    rtl_433

    # frequently used dev tools
    #diffoscope
    qemu
    valgrind
  ];

  programs.bash.enableCompletion = true;

  # syncthing is available on http://127.0.0.1:8384/
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "rick";
    configDir = "/home/rick/.config/syncthing";
  };

  # hydra is available on http://localhost:3000/
  services.hydra = {
    package = pkgs.hydra-unstable;
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    # Enable to only use localhost, disable or set to /etc/nix/machines to enable remote builders as well.
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
  services.postgresql.package = pkgs.postgresql_14;

  # For android studio
  #programs.adb.enable = true;

  # Add unfree packages that should be installed here.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  #nixpkgs.config.contentAddressedByDefault = true;

  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # 25565 for minecraft
  # 6567 for mindustry
  # 51413 for transmission
  # 5201 for iperf3
  # 5000 for development servers
  networking.firewall.allowedTCPPorts = [
    #25565
    #6567
    #51413
    #5201
    5000
  ];
  # 20595 for 0ad
  # 6567 for mindustry
  networking.firewall.allowedUDPPorts = [
    #20595
    #6567
  ];
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

  services.printing.enable = true;
  services.avahi = {
    domainName = "local";
    enable = true;
    interfaces = [ "wlp2s0" ];
    nssmdns = true;
    openFirewall = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # e.g. platformio and element use this, so make sure this is enabled.
  security.unprivilegedUsernsClone = true;

  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [ "wheel" "networkmanager" "dialout" "adbusers" "plugdev" ];
    initialPassword = "rikkert";
  };


  system.stateVersion = "21.11";
}

