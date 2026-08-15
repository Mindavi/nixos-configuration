{ lib, config, ... }:

let
  # TODO(Mindavi): consider this: https://discourse.nixos.org/t/detect-build-vm-in-flake/20648
  isVmBuild = builtins.trace "building as vm: ${lib.boolToString (config.virtualisation ? qemu)}" (
    config.virtualisation ? qemu
  );
in
{
  systemd.network = {
    enable = true;
    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = if isVmBuild then "no" else "yes";
    };
  };
  # Extra logging for debugging.
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  networking = {
    hostName = "aqua";
    # head -c 8 /etc/machine-id
    hostId = "c496aec3";
    networkmanager.enable = false;
    # Managed by networkd.
    useDHCP = false;
    dhcpcd.enable = false;
  };
}
