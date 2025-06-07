{
  pkgs,
  lib,
  hydra_exporter,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/backup.nix
    ./modules/firewall.nix
    ./modules/gaming.nix
    ./modules/jellyfin.nix
    ./modules/nix.nix
    ./modules/nvidia.nix
    ./modules/printer-scanner.nix
    ./modules/prometheus.nix
    ./modules/samba.nix
    ./modules/syncthing.nix
    ./modules/wireguard.nix
    # ../../modules/hydra.nix
    ../../modules/iperf.nix
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

  #programs.nixvim = {
  #  enable = true;
  #};

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
  boot.kernel.sysctl = {
    # https://www.kernel.org/doc/html/latest/mm/overcommit-accounting.html
    "vm.overcommit_memory" = "0";
  };

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "nixos-asus";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  #networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces = {
    wlp2s0 = {
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.178.3";
          prefixLength = 24;
        }
      ];
    };
  };
  # Prevent waiting for DHCP if running in a VM.
  networking.dhcpcd.wait = "if-carrier-up";
  #systemd.network.wait-online.timeout = 5;
  #systemd.network.wait-online.enable = false;

  #networking.usePredictableInterfaceNames = true;
  #systemd.network.enable = true;
  #networking.useNetworkd = true;

  networking.hosts = {
    "192.168.178.8" = [
      "aqua"
      "hass.aqua"
      "hydra.aqua"
      "music-assistant.aqua"
      "prometheus.aqua"
      "traefik.aqua"
    ];
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    hydra_exporter

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
    #digikam
    fdupes
    mqttui # handy for mqtt debugging/logging
    mqttx
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
    #telegram-desktop

    rtl_433

    # frequently used dev tools
    diffoscopeMinimal
    qemu
    valgrind
    nixpkgs-review
    nix-output-monitor
    treefmt

    remmina

    # https://github.com/NixOS/nixpkgs/issues/66093
    adwaita-icon-theme

    android-tools
    chromium

    nixfmt-rfc-style
    zed-editor
    nixd

    # samba
    cifs-utils
    samba4Full

    # DLNA
    minidlna
    ums # universal media server
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web

    # Communication to smart meter
    socat
    #ser2net

    # Hard disk monitoring
    smartmontools
    gsmartcontrol

    # Scanner
    simple-scan
    kdePackages.skanlite

    # secret management
    age
    age-plugin-yubikey
    keepassxc
    ssh-to-age
  ];

  #virtualisation.virtualbox.host.enable = true;

  programs.bash.completion.enable = true;

  services.postgresql.package = pkgs.postgresql_14;

  # For android studio
  #programs.adb.enable = true;

  # Add unfree packages that should be installed here.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "steam"
      "steam-original"
      "steam-run"
      "steam-runtime"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
    ];

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
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };

  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

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
      "kvm"
      "scanner"
    ];
    initialPassword = "rikkert";
  };

  system.stateVersion = "21.11";
}
