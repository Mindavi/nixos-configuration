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
  networking = {
    hostName = "castle";
    hostId = "676dc1cb";
    networkmanager.enable = false;
    # Disable global useDhcp flag, it is deprecated.
    useDHCP = false;
    interfaces = lib.optionalAttrs (!isVmBuild) {
      enp2s0 = {
        # Intentionally enable both DHCP and static IP.
        # This can be handy for recovery when network config is changed.
        # Also, ideally the router handles that the same IP keeps being set up.
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.1.10";
            prefixLength = 24;
          }
        ];
        # For IPv6 SLAAC and DHCPv6 are used. No need to define static IPs here.
      };
    };
  };
}
