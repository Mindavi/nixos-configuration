{ config, pkgs, lib, ... }:

let
  hydraForCa = pkgs.hydra-unstable.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "regnat";
      repo = "hydra";
      rev = "df4835bd105eaff5d3be781ad5afda52f965c0a9";
      sha256 = "sha256-B5UA9dXucR92cWt6p+XQVi8HJu+U6RVlfz8jGI4yfuU=";
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

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
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


  # hydra is available on http://localhost:3000/
  services.hydra = {
    package = hydraForCa;
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@Localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };

  # For android studio
  #programs.adb.enable = true;

  virtualisation.libvirtd.qemuRunAsRoot = false;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.enable = true;

  # Add unfree packages that should be installed here.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  #nixpkgs.config.contentAddressedByDefault = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  services.printing.enable = true;
  # avahi doesn't seem to work properly
  #services.avahi = {
  #  enable = true;
  #  nssmdns = true;
  #  openFirewall = true;
  #};

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.rtl-sdr.enable = true;
  services.udev.packages = [ pkgs.rtl-sdr ];

  security.sudo.extraConfig = ''
    Defaults insults
  '';

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

  #virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "adbusers" "plugdev" "libvirtd" ];
    initialPassword = "rikkert";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

