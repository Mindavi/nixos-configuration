nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount machines/castle/modules/disko.nix --yes-wipe-all-disks
nixos-install --flake .# castle

