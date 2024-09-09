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
    #strictDepsByDefault = true;
    # error: The `env` attribute set cannot contain any attributes passed to derivation. The following attributes are overlapping:
    # - BASH_SHELL: in `env`: "/bin/sh"; in derivation arguments: "/bin/sh"
    # - NIX_CFLAGS_COMPILE: in `env`: ""; in derivation arguments: ""
    # - is64bit: in `env`: true; in derivation arguments: true
    # - linuxHeaders: in `env`: <derivation linux-headers-6.9>; in derivation arguments: <derivation linux-headers-6.9>
    #structuredAttrsByDefault = true;
  };

  #documentation.enable = false;

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

  # Prevent waiting for DHCP if running in a VM.
  networking.dhcpcd.wait = "if-carrier-up";
  #systemd.network.wait-online.timeout = 5;
  #systemd.network.wait-online.enable = false;

  #networking.usePredictableInterfaceNames = true;
  #systemd.network.enable = true;
  #networking.useNetworkd = true;

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
    deepin.deepin-calculator # calculator gui application
    qalculate-qt # calculator gui application

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
    adwaita-icon-theme
  ];

  #virtualisation.virtualbox.host.enable = true;

  programs.bash.completion.enable = true;

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
    package = (pkgs.hydra.overrideAttrs(oldAttrs: {
      version = "0-unstable-2024-08-27-mindavi";
      patches = (/*oldAttrs.patches or */ []) ++ [
        # https://github.com/NixOS/hydra/pull/1372
        (pkgs.fetchpatch2 {
          url = "https://github.com/NixOS/hydra/commit/8e7746d1e38776554a312da5491b98f86a80de76.patch";
          name = "show-build-step-names.patch";
          hash = "sha256-7CUfoXzzzfjNU2IyxvGhGbDg3lVdI8K3FQovUOQvh5E=";
        })
        (pkgs.fetchpatch2 {
          url = "https://github.com/NixOS/hydra/commit/bd380f694e71e1b9bff7db2f12de6ade94a1edd2.patch";
          name = "only-show-stepname-not-equal-drv-name.patch";
          hash = "sha256-OtNmdLHvsa2XPlSkJM2hH1zi/igcRTX40qq9PNTtpAI=";
        })
        # https://github.com/NixOS/hydra/pull/875
        #./patches/nixos-hydra-pull-875.patch
      ];
    }));
    #.override {
    #  nix = pkgs.nixVersions.nix_2_22;
    #};
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    # Enable to only use localhost, disable or set to /etc/nix/machines to enable remote builders as well.
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    extraConfig = ''
      # Uses quite a bit of memory, so prevent multiple evals at once to reduce chance of memory exhaustion.
      max_concurrent_evals = 1
    '';
  };
  systemd.services.hydra-send-stats.enable = false;
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
  networking.firewall.logRefusedConnections = true;
  networking.firewall.logReversePathDrops = true;
  networking.firewall.rejectPackets = true;

  nix = {
    package = pkgs.nixVersions.nix_2_24;
    settings = {
      sandbox = true;
      # decrease max number of jobs to prevent highly-parallelizable jobs from context-switching too much
      # see https://nixos.org/manual/nix/stable/#chap-tuning-cores-and-jobs
      max-jobs = 4;
      # since buildCores warns about non-reproducibility, I'll not touch it -- for now.

      trusted-public-keys = [];
      substituters = [];
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
    buildMachines = [];
    distributedBuilds = true;
    registry.nixpkgs.to = { type = "path"; path = pkgs.path; };
    nixPath = [ "nixpkgs=${pkgs.path}" ];
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # e.g. platformio and element use this, so make sure this is enabled.
  security.unprivilegedUsernsClone = true;

  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    # Enable touchpad support.
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.plasma5.enable = true;
    };
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

