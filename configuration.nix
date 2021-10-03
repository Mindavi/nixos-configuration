{ config, pkgs, lib, ... }:

let
  hydraForCa = pkgs.hydra-unstable.overrideAttrs (oldAttrs: rec {
    version = "unstable-content-addressed";
    src = pkgs.fetchFromGitHub {
      owner = "Mindavi";
      repo = "hydra";
      rev = "52656b488018b6d16e56c3b9dc942229ab1efd33";
      sha256 = "sha256-ysMCV4qkdB4sJ29JDJrSal1fzo5WaTKcgarcoRhL0uU=";
    };
  });
in
{
  imports =
    [
      ./hardware-configuration.nix
      # slowness abound
      #<nixpkgs/nixos/modules/profiles/hardened.nix>
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
    "192.168.220.89" = [ "berekenend" ];
    "192.168.220.10" = [ "pve-bokkenpoot" ];
    "192.168.2.8" = [ "aqua" ];
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "10.8.0.20/32" ];
        privateKeyFile = "/home/rick/.wireguard/key.priv";
        allowedIPsAsRoutes = true;
        peers = [
          {
            endpoint = "kubus.maartendekruijf.nl:51821";
            publicKey = "lZRBtuENLle0JB1oXu59bdJ/HZp6gW5PlXWXY1X4xTw=";
            allowedIPs = [
              # External devices
              "10.8.0.0/24"
              # VMs
              "192.168.220.0/24"
            ];
            persistentKeepalive = 15;
          }
        ];
      };
    };
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

    # pdf viewer
    okular

    # photo viewer
    nomacs

    # communication
    discord
    element-desktop
    irssi
    thunderbird
    tdesktop

    rtl_433
  ];

  programs.bash.enableCompletion = true;
  programs.steam.enable = true;

  # syncthing is available on http://127.0.0.1:8384/
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "rick";
    configDir = "/home/rick/.config/syncthing";
  };

  programs.ssh.extraConfig = ''
    Host berekenend
      Port 22
      User rick

      IdentityFile /home/rick/.ssh/nix_remote
      IdentityFile /home/rick/.ssh/id_ed25519
      StrictHostKeyChecking accept-new
      PubkeyAcceptedKeyTypes ssh-ed25519
  '';


  # hydra is available on http://localhost:3000/
  services.hydra = {
    package = hydraForCa;
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@Localhost";
    # Enable to only use localhost, disable or set to /etc/nix/machines to enable remote builders as well.
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };

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
  networking.firewall.allowedTCPPorts = [
    #25565
    #6567
    #51413
    #5201
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
      experimental-features = nix-command flakes ca-derivations ca-references
      builders-use-substitutes = true
      timeout = 86400 # 24 hours
    '';
    #binaryCaches = [
    #  "https://cache.ngi0.nixos.org/"
    #];
    #binaryCachePublicKeys = [
    #  "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
    #];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    buildMachines = [
      { hostName = "berekenend";
        sshUser = "rick";
        sshKey = "/home/rick/.ssh/nix_remote";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" "ca-derivations" ];
        mandatoryFeatures = [ ];
      }
    ];
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

  hardware.rtl-sdr.enable = true;
  services.udev.packages = [ pkgs.rtl-sdr ];

  security.sudo = {
    package = pkgs.sudo.override {
      withInsults = true;
    };
    execWheelOnly = true;
    extraConfig = ''
      Defaults insults
    '';
  };

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

