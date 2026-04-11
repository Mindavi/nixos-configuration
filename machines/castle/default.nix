{
  config,
  pkgs,
  lib,
  ...
}:

let
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
    ./modules/bind.nix
    ./modules/disko.nix
    ./modules/fail2ban.nix
    ./modules/firewall.nix
    ./modules/impermanence.nix
    ./modules/network.nix
    ./modules/nix.nix
    ./modules/prometheus.nix
    ./modules/sops.nix
    ./modules/ssh.nix
    ./modules/webdav.nix
    ./modules/wireguard.nix
    ./modules/zfs.nix
    #../../modules/hydra.nix
    ../../modules/iperf.nix
    ../../modules/sudo.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = latestKernelPackage;
  # Machine seems to give machine check exceptions.
  # But this post on LKML seems to say that they are invalid errors.
  # https://lkml.org/lkml/2026/3/2/1553
  # Memtest86+ on 2026-03-23/24 did not give any RAM errors.
  hardware.cpu.amd.updateMicrocode = true;

  time.timeZone = "Europe/Amsterdam";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
  };

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    git
    htop
    jpeginfo # verify validity of jpegs
    jq
    parted
    ripgrep # grep
    sbctl # secure boot
    screen
    sl
    transmission_4
    tree
    vim
    zfs
    zip

    memtester
    stress-ng
  ];

  programs.bash.completion.enable = true;

  nixpkgs.config = {
    contentAddressedByDefault = true;
    #strictDepsByDefault = true;
    # error: The `env` attribute set cannot contain any attributes passed to derivation. The following attributes are overlapping:
    # - BASH_SHELL: in `env`: "/bin/sh"; in derivation arguments: "/bin/sh"
    # - NIX_CFLAGS_COMPILE: in `env`: ""; in derivation arguments: ""
    # - is64bit: in `env`: true; in derivation arguments: true
    # - linuxHeaders: in `env`: <derivation linux-headers-6.9>; in derivation arguments: <derivation linux-headers-6.9>
    #structuredAttrsByDefault = true;
  };

  # Define a user account. Don't forget to set a password with `passwd`.
  users.users.rick = {
    isNormalUser = true;
    uid = 1000;
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
  services.postgresql.package = pkgs.postgresql_18;
  system.stateVersion = "25.11";
}
