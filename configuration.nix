{ config, pkgs, lib, ... }:

let
  CatalystPluginPrometheusTiny = pkgs.buildPerlPackage {
    pname = "Catalyst-Plugin-PrometheusTiny";
    version = "0.005";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/S/SY/SYSPETE/Catalyst-Plugin-PrometheusTiny-0.005.tar.gz";
      sha256 = "a42ef09efdc3053899ae007c41220d3ed7207582cc86e491b4f534539c992c5a";
    };
    buildInputs = with pkgs.perlPackages; [ HTTPMessage Plack SubOverride TestDeep ];
    propagatedBuildInputs = with pkgs.perlPackages; [ CatalystRuntime Moose PrometheusTiny PrometheusTinyShared ];
    meta = {
      description = "Prometheus metrics for Catalyst";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  DataRandom = pkgs.buildPerlPackage {
    pname = "Data-Random";
    version = "0.13";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/B/BA/BAREFOOT/Data-Random-0.13.tar.gz";
      sha256 = "eb590184a8db28a7e49eab09e25f8650c33f1f668b6a472829de74a53256bfc0";
    };
    buildInputs = with pkgs.perlPackages; [ FileShareDirInstall TestMockTime ];
    meta = {
      description = "Perl module to generate random data";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashSharedMem = pkgs.perlPackages.buildPerlModule {
    pname = "Hash-SharedMem";
    version = "0.005";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Hash-SharedMem-0.005.tar.gz";
      sha256 = "324776808602f7bdc44adaa937895365454029a926fa611f321c9bf6b940bb5e";
    };
    buildInputs = with pkgs.perlPackages; [ ScalarString ];
    meta = {
      description = "Efficient shared mutable hash";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  PrometheusTiny = pkgs.buildPerlPackage {
    pname = "Prometheus-Tiny";
    version = "0.007";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBN/Prometheus-Tiny-0.007.tar.gz";
      sha256 = "0ef8b226a2025cdde4df80129dd319aa29e884e653c17dc96f4823d985c028ec";
    };
    buildInputs = with pkgs.perlPackages; [ HTTPMessage Plack TestException ];
    meta = {
      homepage = "https://github.com/robn/Prometheus-Tiny";
      description = "A tiny Prometheus client";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PrometheusTinyShared = pkgs.buildPerlPackage {
    pname = "Prometheus-Tiny-Shared";
    version = "0.023";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROBN/Prometheus-Tiny-Shared-0.023.tar.gz";
      sha256 = "7c2c72397be5d8e4839d1bf4033c1800f467f2509689673c6419df48794f2abe";
    };
    buildInputs = with pkgs.perlPackages; [ DataRandom HTTPMessage Plack TestDifferences TestException ];
    propagatedBuildInputs = with pkgs.perlPackages; [ HashSharedMem JSONXS PrometheusTiny ];
    meta = {
      homepage = "https://github.com/robn/Prometheus-Tiny-Shared";
      description = "A tiny Prometheus client with a shared database behind it";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  customPerlDeps = pkgs.buildEnv {
    name = "hydra-perl-deps-content-addressed";
    paths = with pkgs.perlPackages; lib.closePropagation
      [ ModulePluggable
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystDevel
        CatalystDispatchTypeRegex
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginPrometheusTiny
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginSmartURI
        CatalystPluginStackTrace
        CatalystRuntime
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXScriptServerStarman
        CatalystXRoleApplicator
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DataDump
        DateTime
        DigestSHA1
        EmailMIME
        EmailSender
        FileSlurp
        IOCompress
        IPCRun
        JSON
        JSONAny
        JSONXS
        LWP
        LWPProtocolHttps
        NetAmazonS3
        NetPrometheus
        NetStatsd
        PadWalker
        Readonly
        PrometheusTiny
        PrometheusTinyShared
        SQLSplitStatement
        SetScalar
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TextDiff
        TextTable
        XMLSimple
        YAML
        pkgs.nixUnstable
        pkgs.nixUnstable.perl-bindings
        pkgs.git
        pkgs.boehmgc
      ];
  };
  hydraForCa = pkgs.hydra-unstable.overrideAttrs (oldAttrs: rec {
    version = "unstable-content-addressed";
    src = pkgs.fetchFromGitHub {
      owner = "regnat";
      repo = "hydra";
      rev = "d20639a322e340770c9672e0181e70e48214a21c";
      sha256 = "sha256-qLKPN76cCztrE/hW1rLoeK8axSSEHJqGXO7uH6J3J5g=";
    };
    buildInputs =
      with pkgs; [
        makeWrapper autoconf automake libtool unzip nukeReferences sqlite libpqxx
        top-git mercurial subversion breezy openssl bzip2 libxslt
        customPerlDeps perl nixUnstable
        postgresql # for running the tests
        nlohmann_json
        boost
    ];
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
    # removed ca-references for now
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
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

  # Due to the hardened kernel, this option is disabled by default.
  # However, e.g. platformio and element use this, so it's easier to just have it enabled.
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

