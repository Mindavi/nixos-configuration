# Checklist for setting up a new host

## General

This list is somewhat targeted to a desktop/laptop.
Some steps could be omitted for a server system.

- Setup disko configuration
    - Fill in disk names by booting live image on new host
- Create script to automate installation
    - E.g. use the initial.sh script from iqaluk
- Setup syncthing for file syncing
- Setup keepass for password management
    - Setup syncing of password file
    - E.g. syncthing
- Enroll TPM2 for disk decryption
    - And/or enroll a physical security key for unlocking
- Enroll secure boot
    - Start with systemd-boot
    - Move over to lanzaboote using the lanzaboote tutorial
- Enroll ssh key in authorizedkeys for all hosts
    - Generate ssh key: ssh-keygen -t ed25519 -C "user@host"
    - Add to authorizedkeys
- Enroll host in sops with ssh-to-age for the main user
    - Generate a key
    - Ensure permissions, e.g. chmod 400 ~/.config/sops/age/keys.txt
- Verify backups are working
- Enroll ssh key in github
- Generate wireguard key (see instructions in aqua/modules/wireguard.nix) and add to all relevant hosts
