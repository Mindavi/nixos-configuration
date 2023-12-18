{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/gaming.nix
      ./modules/nvidia.nix
      ../../modules/sudo.nix
      ../../modules/rtl-sdr.nix
    ];

  nixpkgs.config = {
    # Even though it's not recommended, I'm going to enable this anyway.
    # I like it to be a hard error when an attribute is renamed or whatever.
    # Can always disable this again when it causes issues.
    allowAliases = false;
    #contentAddressedByDefault = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

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

  networking.hostName = "nixos-asus";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  #networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking.hosts = {
    "192.168.2.7" = [ "raspberry" ];
    "192.168.1.8" = [ "aqua" ];
    "192.168.1.123" = [ "printer" ];
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    # rust cli tools
    eza # ls
    bat # cat
    ripgrep # grep
    fzf # fuzzy find
    pv # pipe viewer

    pciutils
    wget
    vim
    firefox
    gitFull
    htop
    keepassxc
    tree
    sl
    vlc
    syncthing
    #transmission
    qbittorrent
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
    mqttui # handy for mqtt debugging/logging
    minicom # for uart / serial debugging

    # pdf viewer
    libsForQt5.okular

    # photo viewer
    nomacs

    # communication
    element-desktop
    irssi
    thunderbird
    telegram-desktop

    rtl_433

    # frequently used dev tools
    diffoscopeMinimal
    qemu
    valgrind
    nixpkgs-review
    nix-output-monitor

    remmina

    # https://github.com/NixOS/nixpkgs/issues/66093
    gnome.adwaita-icon-theme
  ];

  #virtualisation.virtualbox.host.enable = true;

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
    "steam-run"
    "steam-runtime"
    "nvidia-x11"
    "nvidia-settings"
  ];

  # Open ports in the firewall.
  # 25565 for minecraft
  # 6567 for mindustry
  # 51413 for transmission
  # 5201 for iperf3
  # 5000 for development servers
  # 8080 for development servers
  networking.firewall.allowedTCPPorts = [
    #25565
    #6567
    #51413
    #5201
    5000
    8080
  ];
  # 20595 for 0ad
  # 6567 for mindustry
  networking.firewall.allowedUDPPorts = [
    20595
    #6567
  ];
  networking.firewall.enable = true;
  networking.firewall.logRefusedPackets = true;

  nix = {
    package = pkgs.nixVersions.nix_2_19;
    settings = {
      sandbox = true;
      # decrease max number of jobs to prevent highly-parallelizable jobs from context-switching too much
      # see https://nixos.org/manual/nix/stable/#chap-tuning-cores-and-jobs
      max-jobs = 4;
      # since buildCores warns about non-reproducibility, I'll not touch it -- for now.

      trusted-public-keys = [
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      substituters = [
        "https://cache.ngi0.nixos.org/"
        "https://nix-community.cachix.org"
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
    buildMachines = [];
    distributedBuilds = true;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  # mDNS doesn't work with TP-Link Deco M5 mesh modules.
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
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
      };
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [ "wheel" "networkmanager" "dialout" "adbusers" "plugdev" "kvm" ];
    initialPassword = "rikkert";
  };

  system.stateVersion = "21.11";
}

