{
  config,
  pkgs,
  lib,
  ...
}:

let
  # TODO(Mindavi): consider this: https://discourse.nixos.org/t/detect-build-vm-in-flake/20648
  isVmBuild = builtins.trace ''building as vm: ${lib.boolToString (config.virtualisation ? qemu)}'' (
    config.virtualisation ? qemu
  );
  # https://wiki.nixos.org/wiki/ZFS
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/audio.nix
    ./modules/avahi.nix
    ./modules/backup.nix
    ./modules/dashboard.nix
    #./modules/disko.nix
    ./modules/fail2ban.nix
    ./modules/firewall.nix
    ./modules/grafana.nix
    ./modules/home-assistant
    ./modules/mosquitto.nix
    ./modules/music-assistant.nix
    ./modules/nix.nix
    ./modules/owncast.nix
    ./modules/prometheus.nix
    ./modules/rtl_433.nix
    ./modules/samba.nix
    #./modules/solar-inverter.nix
    ./modules/sops.nix
    ./modules/traefik.nix
    #./modules/virtualisation.nix
    ./modules/wireguard.nix
    ./modules/zfs.nix
    ./modules/zigbee2mqtt.nix
    #../../modules/hydra.nix
    ../../modules/iperf.nix
    ../../modules/rtl-sdr.nix
    ../../modules/sudo.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = latestKernelPackage;
  #boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.bluetooth.enable = true;

  networking.hostName = "aqua";
  # head -c 8 /etc/machine-id
  networking.hostId = "c496aec3";
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;

  networking.interfaces = lib.optionalAttrs (!isVmBuild) {
    eno1 = {
      # Intentionally enable both DHCP and static IP.
      # This can be handy for recovery when network config is changed.
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.1.8";
          prefixLength = 24;
        }
      ];
      # TODO(Mindavi): ipv6 address.
    };
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    gitAndTools.gitFull
    htop
    jpeginfo # verify validity of jpegs
    jq
    parted
    ripgrep # grep
    screen
    sl
    syncthing
    #transmission_4
    tree
    usbutils
    vim
    zfs
    zip
  ];

  programs.bash.completion.enable = true;

  # TODO: add syncthing

  services.openssh.enable = true;

  networking.firewall.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/nix"
      "/home"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    home = "/home/rick";
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "networkmanager"
      "plugdev"
      "wheel"
    ];
    initialPassword = "rikkert1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus"
    ];
  };
  users.mutableUsers = true;
  services.userborn.enable = true;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.05";
}
