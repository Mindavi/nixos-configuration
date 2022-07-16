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
    gitFull
    htop
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
    libsForQt5.okular

    # photo viewer
    nomacs

    # communication
    element-desktop
    irssi
    thunderbird
    tdesktop

    rtl_433

    # frequently used dev tools
    diffoscopeMinimal
    qemu
    valgrind
    nixpkgs-review

    remmina
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
    package = pkgs.hydra_unstable;
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
    "nvidia-x11"
    "nvidia-settings"
  ];

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

  nix = let
    nix' = (pkgs.nixVersions.nix_2_9.override { enableDocumentation = false; }).overrideAttrs(oldAttrs: {
      pname = "nix-with-sanitizers";
      # False if ASAN is enabled since some tests then start failing.
      doInstallCheck = true;
      NIX_CFLAGS_COMPILE = "-fstack-protector-all -fsanitize=undefined -fsanitize-recover=all -fno-common -fno-omit-frame-pointer -O1 -fno-optimize-sibling-calls";

      # TODO: check if these flags do anything and don't break the build.
      #CFLAGS = [ "-fstack-protector-all" ];
      #CXXFLAGS = [ "-fstack-protector-all" ];

      patches = oldAttrs.patches or [] ++ [
        (pkgs.fetchpatch {
          name = "asan-disable-leak-detection-most-apps";
          url = "https://github.com/Mindavi/nix/commit/24a26b40fd6d1714d40851b13eaa4273b7d5536f.patch";
          hash = "sha256-Qg+/f9aFzp/OHLZ0fRidLlk23+MItyELJbaNKYNL54g=";
        })
        (pkgs.fetchpatch {
          name = "tests-disable-decompression-error-test";
          url = "https://github.com/Mindavi/nix/commit/d51915ea25ecc25c6d4a8138465b9fca8256c114.patch";
          hash = "sha256-/GtpMY8a9ZrVcNW6jhVID9oBYbglfKs+fKnnwTBI3TI=";
        })
        (pkgs.fetchpatch {
          name = "enable-asan-ubsan";
          url = "https://github.com/Mindavi/nix/commit/330c5b8d126de7508e6316e5a453eccdb1467961.patch";
          hash = "sha256-qsf99K0k6c9OTEsma58CgwAGoXnp4zdq8UTmYvyuTAk=";
        })
        (pkgs.fetchpatch {
          name = "asan-disable-leak-detection-nix-app";
          url = "https://github.com/Mindavi/nix/commit/f7d3ba738b75246426a9be8697a4ddccb9b64f71.patch";
          hash = "sha256-iaGEINjmQH6mPtWddGORzYfXwysucn46D526U/XUrm8=";
        })
        (pkgs.fetchpatch {
          name = "disable-asan-again";
          url = "https://github.com/Mindavi/nix/commit/d8ab900d94a8108a22860eac4d0165e834e63302.patch";
          hash = "sha256-ZY2AmGOALTrAk0V1txUF6ygYkdXNsi0kp25CUaxElV4=";
        })
        (pkgs.fetchpatch {
          name = "cast-rowid-to-correct-type-GH6716";
          url = "https://github.com/NixOS/nix/commit/2beb929753d28604ccd40057fca295a11640e40e.patch";
          hash = "sha256-8ktSFWxLTtX0Btc/MQqGI35OpEvttH+zTTz/ZJPGGMw=";
        })
        ./patches/nix-tag-unexpected-eof.diff
      ];
    });
  in
  {
    package = nix';
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
    extraGroups = [ "wheel" "networkmanager" "dialout" "adbusers" "plugdev" "kvm" ];
    initialPassword = "rikkert";
  };


  system.stateVersion = "21.11";
}

