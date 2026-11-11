{
  lib,
  config,
  ...
}:

let
  # TODO(Mindavi): consider this: https://discourse.nixos.org/t/detect-build-vm-in-flake/20648
  isVmBuild = builtins.trace "building as vm: ${lib.boolToString (config.virtualisation ? qemu)}" (
    config.virtualisation ? qemu
  );
in
{
  systemd.network = {
    enable = true;
    networks."10-enp2s0" = {
      matchConfig.Name = "enp2s0";
      networkConfig = {
        # Note(Mindavi): to try again, this is required to fix ipv4 missing:
        # - sudo ip addr add 192.168.1.159/24 dev enp2s0 broadcast 192.168.1.255 noprefixroute
        # - sudo ip route add default via 192.168.1.1 dev enp2s0 onlink
        # Don't disable ipv4 without having a way to connect to github...
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        MulticastDNS = "yes";
      };
      linkConfig.RequiredForOnline = if isVmBuild then "no" else "yes";
    };
  };
  # Extra logging for debugging.
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  networking = {
    hostName = "castle";
    hostId = "676dc1cb";
    networkmanager.enable = false;
    # Managed by networkd.
    useDHCP = false;
    dhcpcd.enable = false;
  };
}
