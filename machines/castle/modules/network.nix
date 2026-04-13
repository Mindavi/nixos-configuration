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
        useDHCP = true;
        # For IPv6 SLAAC and DHCPv6 are used. No need to define static IPs here.
      };
    };
    dhcpcd.extraConfig = ''
      debug
    '';
  };
}
