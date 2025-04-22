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
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/avahi.nix
    ./modules/backup.nix
    ./modules/dashboard.nix
    ./modules/fail2ban.nix
    ./modules/firewall.nix
    ./modules/grafana.nix
    ./modules/home-assistant
    ./modules/mosquitto.nix
    ./modules/nix.nix
    ./modules/prometheus.nix
    ./modules/rtl_433.nix
    ./modules/samba.nix
    #./modules/solar-inverter.nix
    ./modules/traefik.nix
    #./modules/virtualisation.nix
    ./modules/wireguard.nix
    ./modules/zigbee2mqtt.nix
    ../../modules/hydra.nix
    ../../modules/iperf.nix
    ../../modules/rtl-sdr.nix
    ../../modules/sudo.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = [ "nouveau.modeset=0" ];

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "aqua";
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
    jq
    parted
    ripgrep # grep
    screen
    sl
    syncthing
    #transmission_4
    tree
    vim
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
      "wheel"
      "networkmanager"
      "dialout"
      "adbusers"
      "plugdev"
    ];
    initialPassword = "rikkert1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus"
    ];
  };
  users.mutableUsers = true;

  services.postgresql.package = pkgs.postgresql_15;

  system.stateVersion = "23.05";
}
