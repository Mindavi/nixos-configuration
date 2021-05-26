# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  # nvidia
  #nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #  export __NV_PRIME_RENDER_OFFLOAD=1
  #  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #  export __VK_LAYER_NV_optimus=NVIDIA_only
  #  exec -a "$0" "$@"
  #'';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # slowness abound
      #<nixpkgs/nixos/modules/profiles/hardened.nix>
    ];

  # for binfmt / aarch compilation
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 7;

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "nixos-asus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp3s0f1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.prime = {
  #  offload.enable = true;
  #  intelBusId = "PCI:0:2:0";
  #  nvidiaBusId = "PCI:1:0:0";
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nvidia enable
    #nvidia-offload

    # rust cli tools
    exa # ls
    bat # cat
    ripgrep # grep
    fzf # fuzzy find
    
    pciutils
    wget
    vim
    firefox 
    thunderbird
    htop
    gitAndTools.gitFull
    keepassxc
    tree
    sl
    vlc
    tdesktop
    syncthing
    #transmission
    fping
    vscodium
    jq

    # pdf viewer
    okular

    # photo viewer
    nomacs
  ];

  #services.transmission.enable = true;

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
    notificationSender = "hydra@Localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  # For android studio
  programs.adb.enable = true;

  virtualisation.libvirtd.qemuRunAsRoot = false;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.enable = true;

  # nvidia
  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #  "nvidia-x11"
  #  "nvidia-settings"
  #];

  #nixpkgs.config.contentAddressedByDefault = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

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
    20595
    6567
  ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    # for binfmt / aarch compilation
    # extra-platforms = aarch64-linux arm-linux
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.rtl-sdr.enable = true;
  services.udev.packages = [ pkgs.rtl-sdr ];

  security.sudo.extraConfig = ''
Defaults	insults
  '';

  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "adbusers" "plugdev" "libvirtd"];
    initialPassword = "rikkert";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

