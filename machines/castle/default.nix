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
    #./modules/audio.nix
    ./modules/avahi.nix
    #./modules/backup.nix
    ./modules/disko.nix
    #./modules/fail2ban.nix
    ./modules/firewall.nix
    #./modules/impermanence.nix
    ./modules/nix.nix
    #./modules/prometheus.nix
    ./modules/sops.nix
    ./modules/wireguard.nix
    ./modules/zfs.nix
    #../../modules/hydra.nix
    #../../modules/iperf.nix
    #../../modules/sudo.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];

  boot.kernelPackages = latestKernelPackage;
  hardware.cpu.amd.updateMicrocode = true;

  networking = {
    hostName = "castle";
    hostId = "676dc1cb";
    networkmanager.enable = false;
    # Disable global useDhcp flag, it is deprecated.
    useDHCP = false;
    interfaces = lib.optionalAttrs (!isVmBuild) {
      eno1 = {
        # Intentionally enable both DHCP and static IP.
        # This can be handy for recovery when network config is changed.
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.1.10";
            prefixLength = 24;
          }
        ];
        # TODO(Mindavi): ipv6 address.
      };
    };
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    gitFull
    htop
    jpeginfo # verify validity of jpegs
    jq
    parted
    ripgrep # grep
    sbctl # secure boot
    screen
    sl
    #syncthing
    #transmission_4
    tree
    vim
    zfs
    zip
  ];

  programs.bash.completion.enable = true;
  services.openssh.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/nix"
      "/home"
    ];
  };

  # Define a user account. Don't forget to set a password with `passwd`.
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
    hashedPassword = "$y$j9T$YFgZE2/erDCM61d0kprpF0$fFuWEGhg4U1CUDCtlzRJKTiCF6E.TMmr7i1RtP3AZ5D";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus"
    ];
  };
  users.mutableUsers = false;

  services.postgresql.package = pkgs.postgresql_17;

  system.stateVersion = "25.11";
}
