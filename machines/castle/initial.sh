#!/usr/bin/env bash
set -euxo pipefail
nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount machines/castle/modules/disko.nix --yes-wipe-all-disks
nixos-install --flake .#castle
umount /mnt/boot
# Note(Mindavi): Very important step, the zpool must be exported, otherwise it won't import after installation!
zpool export -fa

