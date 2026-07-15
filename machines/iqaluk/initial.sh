#!/usr/bin/env bash
set -euxo pipefail
# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
hostname=$(basename $SCRIPT_DIR)
nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount "$SCRIPT_DIR/modules/disko.nix" --yes-wipe-all-disks
nixos-install --flake .#$hostname
umount /mnt/boot
# Note(Mindavi): Very important step, the zpool must be exported, otherwise it won't import after installation!
zpool export -fa

