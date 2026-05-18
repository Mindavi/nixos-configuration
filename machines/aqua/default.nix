{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/audio.nix
    ./modules/avahi.nix
    ./modules/backup.nix
    ./modules/bind.nix
    ./modules/dashboard.nix
    ./modules/disko.nix
    ./modules/fail2ban.nix
    ./modules/firewall.nix
    ./modules/grafana.nix
    ./modules/home-assistant
    ./modules/immich.nix
    ./modules/llm.nix
    ./modules/mosquitto.nix
    ./modules/music-assistant.nix
    ./modules/network.nix
    ./modules/nix.nix
    #./modules/owncast.nix
    ./modules/prometheus.nix
    ./modules/radicale.nix
    ./modules/rtl_433.nix
    ./modules/samba.nix
    ./modules/sops.nix
    ./modules/spotifyd.nix
    ./modules/squeezelite.nix
    ./modules/syncthing.nix
    ./modules/traefik.nix
    ./modules/users.nix
    #./modules/virtualisation.nix
    ./modules/voice.nix
    ./modules/webdav.nix
    ./modules/wireguard.nix
    ./modules/zigbee2mqtt.nix
    #../../modules/hydra.nix
    ../../modules/iperf.nix
    ../../modules/rtl-sdr.nix
    ../../modules/sudo.nix
    ../../modules/zfs.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = false;

  # The system will try to boot as far as possible even if mounting (or other services) fail.
  # Otherwise it will be dropped in an emergency shell (without SSH access).
  systemd.enableEmergencyMode = false;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    fdupes
    file
    fzf # fuzzy find
    gitFull
    hdparm
    htop
    jpeginfo # verify validity of jpegs
    jq
    parted
    ripgrep # grep
    screen
    sl
    syncthing
    tree
    usbutils
    vim
    zfs
    zip
  ];

  programs.bash.completion.enable = true;

  services.openssh.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    # fileSystems should be determined automatically.
  };

  services.postgresql.package = pkgs.postgresql_18;

  system.stateVersion = "23.05";
}
