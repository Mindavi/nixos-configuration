{ lib, config, ... }:

let
  # TODO(Mindavi): consider this: https://discourse.nixos.org/t/detect-build-vm-in-flake/20648
  isVmBuild = builtins.trace "building as vm: ${lib.boolToString (config.virtualisation ? qemu)}" (
    config.virtualisation ? qemu
  );
in
{
  networking = {
    hostName = "aqua";
    # head -c 8 /etc/machine-id
    hostId = "c496aec3";
    networkmanager.enable = false;

    # Somehow, on 2026-08-14 the whole network config broke with this disable. Re-enable for now.
    useDHCP = true;

    interfaces = lib.optionalAttrs (!isVmBuild) {
      eno1 = {
        useDHCP = true;
        # For IPv6 SLAAC and DHCPv6 are used. No need to define static IPs here.
      };
    };
    dhcpcd.extraConfig = ''
      debug
    '';
  };
}
