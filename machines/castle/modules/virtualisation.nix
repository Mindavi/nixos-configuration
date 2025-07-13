{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
    "${toString modulesPath}/virtualisation/qemu-vm.nix"
  ];
}
